import 'dart:math';

import '../../../database/app_database.dart';
import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

/// Generador de "Hyrox": simula la estructura oficial de la carrera
/// (1km de carrera + estación, repetido) con las 8 estaciones reales
/// (SkiErg, Sled Push, Sled Pull, Burpee Broad Jump, Remo, Farmers Carry,
/// Sandbag Lunges y Wall Balls), más activación, fuerza complementaria
/// (carrera comprometida, agarre, core anti-rotación) y enfriamiento.
class HyroxGenerator {
  HyroxGenerator(this.repository, {int? seed})
    : random = seed != null ? Random(seed) : Random();

  final ExerciseRepository repository;
  final Random random;

  static const String categoryName = "Hyrox";
  static const int totalMinutes = 60;

  /// Cuántas estaciones (de las 8 oficiales) entran en la simulación de
  /// hoy: una sesión completa de las 8 supera con facilidad los 60
  /// minutos disponibles, así que cada día se practica un subconjunto.
  static const int stationsPerSession = 4;

  static const String _runningStationName = "Carrera de Estación 1 km";

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

  /// Alterna carrera y estación, igual que la carrera real: correr, hacer
  /// una estación, correr, la siguiente estación...
  List<WorkoutExerciseModel> _buildSimulation(
    List<Exercise> pool,
    Map<int, String> equipmentNames,
  ) {
    final runExercise = pool.firstWhere(
      (exercise) => exercise.name == _runningStationName,
      orElse: () => pool.first,
    );
    final stations = pool.where((e) => e.id != runExercise.id).toList()
      ..shuffle(random);

    final picked = stations.take(stationsPerSession).toList();
    if (picked.isEmpty) return [];

    usedExercises.add(runExercise.id);
    for (final station in picked) {
      usedExercises.add(station.id);
    }

    final exercises = <WorkoutExerciseModel>[];

    for (final station in picked) {
      exercises.add(
        WorkoutExerciseModel(
          name: runExercise.name,
          equipment: equipmentNames[runExercise.equipmentId],
          distance: "1 km",
          notes: runExercise.description,
        ),
      );

      exercises.add(
        WorkoutExerciseModel(
          name: station.name,
          equipment: equipmentNames[station.equipmentId],
          notes: station.description,
          weight: WeightSuggestion.forExercise(station.name)?.label,
        ),
      );
    }

    return exercises;
  }

  Future<WorkoutModel> generate() async {
    usedExercises.clear();

    final warmupMinutes = 8 + random.nextInt(5); // 8-12
    final simulationMinutes = 30 + random.nextInt(6); // 30-35
    final accessoryMinutes = 10 + random.nextInt(4); // 10-13
    final cooldownMinutes =
        totalMinutes - (warmupMinutes + simulationMinutes + accessoryMinutes);

    final equipmentNames = await repository.getEquipmentNames();

    final warmups = await repository.getWarmupExercisesForCategory(
      categoryName,
    );
    final stationsPool = await repository.getStrengthExercisesForCategory(
      categoryName,
    );
    final accessory = await repository.getAccessoryExercisesForCategory(
      categoryName,
    );
    final cooldowns = await repository.getCooldownExercisesForCategory(
      categoryName,
    );

    return WorkoutModel(
      title: "Hyrox del Día",
      type: "Hyrox",
      sections: [
        WorkoutSectionModel(
          name: "Calentamiento",
          subtitle: "Activación general",
          durationMinutes: warmupMinutes,
          exercises: _pickDrills(
            warmups,
            3,
            equipmentNames,
            sets: "1-2",
            repsLabel: "10-15",
          ),
        ),

        WorkoutSectionModel(
          name: "Simulación Hyrox",
          subtitle: "$stationsPerSession km + $stationsPerSession estaciones",
          durationMinutes: simulationMinutes,
          exercises: _buildSimulation(stationsPool, equipmentNames),
        ),

        WorkoutSectionModel(
          name: "Fuerza Complementaria",
          subtitle: "Agarre y carrera comprometida",
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
