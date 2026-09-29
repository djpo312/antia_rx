import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../features/workout/workout_model.dart';

class CustomWodRepository {
  final AppDatabase database;

  CustomWodRepository(this.database);

  /// Obtiene el WOD personalizado de hoy (si existe).
  /// Devuelve null si no hay.
  Future<WorkoutModel?> getTodayCustomWod() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59, 999);

    final workouts = await database.customWorkoutsForDateRange(startOfDay, endOfDay);

    if (workouts.isEmpty) return null;

    final workout = workouts.first;
    return _workoutToDomain(workout);
  }

  /// Guarda un WOD personalizado (reemplaza si ya existe uno de hoy).
  Future<int> saveCustomWod(WorkoutModel model) async {
    // Primero, elimina cualquier WOD personalizado de hoy
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59, 999);

    await database.deleteCustomWorkoutsForDateRange(startOfDay, endOfDay);

    // Luego, guarda el nuevo
    final workoutId = await database.into(database.workouts).insert(
          WorkoutsCompanion.insert(
            name: model.title,
            description: model.sections.map((s) => s.name).join(', '),
            type: 'crossfit',
            level: 'Custom',
            estimatedMinutes: model.totalMinutes,
          ),
        );

    // Guarda los ejercicios asociados
    int orderIndex = 0;
    for (int sectionIdx = 0; sectionIdx < model.sections.length; sectionIdx++) {
      final section = model.sections[sectionIdx];
      for (final exercise in section.exercises) {
        // Busca el ID del ejercicio por nombre en la BD
        final exerciseId = await _getExerciseIdByName(exercise.name);
        if (exerciseId != null) {
          await database.into(database.workoutExercises).insert(
                WorkoutExercisesCompanion.insert(
                  workoutId: workoutId,
                  exerciseId: exerciseId,
                  sectionId: sectionIdx,
                  orderIndex: orderIndex,
                  sets: int.tryParse(exercise.sets ?? '0') ?? 0,
                  reps: int.tryParse(exercise.reps ?? '0') ?? 0,
                  weight: double.tryParse(exercise.weight ?? '0') ?? 0,
                  durationSeconds: _parseDuration(exercise.duration),
                  restSeconds: 60,
                ),
              );
          orderIndex++;
        }
      }
    }

    return workoutId;
  }

  /// Convierte un Workout de Drift a WorkoutModel de dominio.
  Future<WorkoutModel> _workoutToDomain(Workout workout) async {
    final exercises = await (database.select(database.workoutExercises)
          ..where((we) => we.workoutId.equals(workout.id))
          ..orderBy([(we) => OrderingTerm.asc(we.orderIndex)]))
        .get();

    // Agrupa ejercicios por sección
    final Map<int, List<WorkoutExercise>> bySectionId = {};
    for (final ex in exercises) {
      bySectionId.putIfAbsent(ex.sectionId, () => []);
      bySectionId[ex.sectionId]!.add(ex);
    }

    // Construye las secciones
    final sections = <WorkoutSectionModel>[];
    for (int i = 0; i < bySectionId.keys.length; i++) {
      final exList = bySectionId[i] ?? [];
      final sectionExercises = <WorkoutExerciseModel>[];

      for (final ex in exList) {
        final exerciseRecord = await (database.select(database.exercises)
              ..where((e) => e.id.equals(ex.exerciseId)))
            .getSingle();

        sectionExercises.add(
          WorkoutExerciseModel(
            name: exerciseRecord.name,
            equipment: null,
            sets: ex.sets > 0 ? '${ex.sets}' : null,
            reps: ex.reps > 0 ? '${ex.reps}' : null,
            weight: ex.weight > 0 ? '${ex.weight.toStringAsFixed(0)}' : null,
            duration: ex.durationSeconds > 0 ? '${ex.durationSeconds}s' : null,
            distance: null,
            notes: null,
          ),
        );
      }

      sections.add(
        WorkoutSectionModel(
          name: _getSectionName(i),
          subtitle: null,
          durationMinutes: null,
          exercises: sectionExercises,
        ),
      );
    }

    return WorkoutModel(
      title: workout.name,
      type: workout.type,
      sections: sections,
    );
  }

  /// Busca el ID de un ejercicio por nombre exacto.
  Future<int?> _getExerciseIdByName(String name) async {
    try {
      final exercise = await (database.select(database.exercises)
            ..where((e) => e.name.equals(name)))
          .getSingle();
      return exercise.id;
    } catch (_) {
      return null;
    }
  }

  /// Convierte nombre de sección por índice.
  String _getSectionName(int index) {
    switch (index) {
      case 0:
        return 'Calentamiento';
      case 1:
        return 'Entrenamiento';
      case 2:
        return 'Fuerza';
      case 3:
        return 'Enfriamiento';
      default:
        return 'Sección ${index + 1}';
    }
  }

  /// Parsea duraciones de texto ("10m", "30s") a segundos.
  int _parseDuration(String? duration) {
    if (duration == null || duration.isEmpty) return 0;
    if (duration.endsWith('m')) {
      return int.tryParse(duration.replaceAll('m', '')) ?? 0 * 60;
    }
    if (duration.endsWith('s')) {
      return int.tryParse(duration.replaceAll('s', '')) ?? 0;
    }
    return int.tryParse(duration) ?? 0;
  }
}
