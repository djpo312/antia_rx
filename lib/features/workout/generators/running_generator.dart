import 'dart:math';

import '../../../database/app_database.dart';
import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

/// Generador de "Running": sesión de 60 minutos con drills de activación,
/// un bloque principal de carrera que varía cada día (series en pista,
/// tempo run, fartlek, carrera larga, cuestas, progresivos...), fuerza
/// complementaria para prevenir lesiones y estiramientos de cierre.
class RunningGenerator {
  RunningGenerator(this.repository, {int? seed})
    : random = seed != null ? Random(seed) : Random();

  final ExerciseRepository repository;
  final Random random;

  static const String categoryName = "Running";
  static const int totalMinutes = 60;

  final Set<int> usedExercises = {};

  List<WorkoutExerciseModel> _pickDrills(
    List<Exercise> source,
    int amount,
    Map<int, String> equipmentNames, {
    String? sets,
    String? repsLabel,
    String? durationLabel,
  }) {
    source.shuffle(random);

    final selected = <WorkoutExerciseModel>[];

    for (final exercise in source) {
      if (usedExercises.contains(exercise.id)) continue;

      usedExercises.add(exercise.id);

      selected.add(
        WorkoutExerciseModel(
          name: exercise.name,
          equipment: equipmentNames[exercise.equipmentId],
          sets: sets,
          reps: repsLabel,
          duration: durationLabel,
        ),
      );

      if (selected.length == amount) break;
    }

    return selected;
  }

  /// El bloque principal (series de 400m, tempo run, carrera larga...) ya
  /// trae su propia prescripción en la descripción del ejercicio: a
  /// diferencia del calentamiento o los accesorios, no tiene sentido
  /// aplicarle un "3x10" genérico encima, así que se usa como nota.
  List<WorkoutExerciseModel> _pickMainWorkout(
    List<Exercise> source,
    Map<int, String> equipmentNames,
  ) {
    if (source.isEmpty) return [];

    source.shuffle(random);

    final exercise = source.first;
    usedExercises.add(exercise.id);

    return [
      WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        notes: exercise.description,
      ),
    ];
  }

  Future<WorkoutModel> generate() async {
    usedExercises.clear();

    final warmupMinutes = 8 + random.nextInt(5); // 8-12
    final mainMinutes = 30 + random.nextInt(11); // 30-40
    final accessoryMinutes = 10 + random.nextInt(4); // 10-13
    final cooldownMinutes =
        totalMinutes - (warmupMinutes + mainMinutes + accessoryMinutes);

    final equipmentNames = await repository.getEquipmentNames();

    final warmups = await repository.getWarmupExercisesForCategory(
      categoryName,
    );
    final main = await repository.getStrengthExercisesForCategory(
      categoryName,
    );
    final accessory = await repository.getAccessoryExercisesForCategory(
      categoryName,
    );
    final cooldowns = await repository.getCooldownExercisesForCategory(
      categoryName,
    );

    return WorkoutModel(
      title: "Running del Día",
      type: "Running",
      sections: [
        WorkoutSectionModel(
          name: "Calentamiento",
          subtitle: "Activación y técnica de carrera",
          durationMinutes: warmupMinutes,
          exercises: _pickDrills(
            warmups,
            3,
            equipmentNames,
            sets: "2",
            repsLabel: "20-30m",
          ),
        ),

        WorkoutSectionModel(
          name: "Entrenamiento Principal",
          subtitle: "El bloque de running de hoy",
          durationMinutes: mainMinutes,
          exercises: _pickMainWorkout(main, equipmentNames),
        ),

        WorkoutSectionModel(
          name: "Fuerza Complementaria",
          subtitle: "Prevención de lesiones",
          durationMinutes: accessoryMinutes,
          exercises: _pickDrills(
            accessory,
            3,
            equipmentNames,
            sets: "2-3",
            repsLabel: "10-15",
          ),
        ),

        WorkoutSectionModel(
          name: "Enfriamiento",
          subtitle: "Estiramiento",
          durationMinutes: cooldownMinutes,
          exercises: _pickDrills(
            cooldowns,
            2,
            equipmentNames,
            durationLabel: "30-45 seg",
          ),
        ),
      ],
    );
  }
}
