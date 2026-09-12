import 'dart:math';

import '../../../database/app_database.dart';
import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

/// Generador de "Gimnasio": una sesión clásica de fuerza/musculación de
/// 60 minutos (no metcon, no formatos de CrossFit): calentamiento, fuerza
/// principal con los básicos de barra, accesorios de aislamiento con
/// mancuerna, y enfriamiento.
class GymGenerator {
  GymGenerator(this.repository, {int? seed})
    : random = seed != null ? Random(seed) : Random();

  final ExerciseRepository repository;
  final Random random;

  static const String categoryName = "Gym";
  static const int totalMinutes = 60;

  final Set<int> usedExercises = {};

  List<WorkoutExerciseModel> _pick(
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

      final weights = WeightSuggestion.forExercise(exercise.name);

      selected.add(
        WorkoutExerciseModel(
          name: exercise.name,
          equipment: equipmentNames[exercise.equipmentId],
          sets: sets,
          reps: repsLabel,
          duration: durationLabel,
          weight: weights?.label,
        ),
      );

      if (selected.length == amount) break;
    }

    return selected;
  }

  Future<WorkoutModel> generate() async {
    usedExercises.clear();

    final warmupMinutes = 8 + random.nextInt(5); // 8-12
    final strengthMinutes = 18 + random.nextInt(5); // 18-22
    final accessoryMinutes = 15 + random.nextInt(4); // 15-18
    final cooldownMinutes =
        totalMinutes - (warmupMinutes + strengthMinutes + accessoryMinutes);

    final equipmentNames = await repository.getEquipmentNames();

    final warmups = await repository.getWarmupExercisesForCategory(
      categoryName,
    );
    final strength = await repository.getStrengthExercisesForCategory(
      categoryName,
    );
    final accessory = await repository.getAccessoryExercisesForCategory(
      categoryName,
    );
    final cooldowns = await repository.getCooldownExercisesForCategory(
      categoryName,
    );

    return WorkoutModel(
      title: "Gimnasio del Día",
      type: "Gym",
      sections: [
        WorkoutSectionModel(
          name: "Calentamiento",
          subtitle: "Activación general",
          durationMinutes: warmupMinutes,
          exercises: _pick(
            warmups,
            3,
            equipmentNames,
            sets: "1-2",
            repsLabel: "10-12",
          ),
        ),

        WorkoutSectionModel(
          name: "Fuerza Principal",
          subtitle: "Básicos con barra",
          durationMinutes: strengthMinutes,
          exercises: _pick(
            strength,
            3,
            equipmentNames,
            sets: "4-5",
            repsLabel: "5-8",
          ),
        ),

        WorkoutSectionModel(
          name: "Accesorios",
          subtitle: "Aislamiento con mancuerna",
          durationMinutes: accessoryMinutes,
          exercises: _pick(
            accessory,
            3,
            equipmentNames,
            sets: "3",
            repsLabel: "10-15",
          ),
        ),

        WorkoutSectionModel(
          name: "Enfriamiento",
          subtitle: "Estiramiento",
          durationMinutes: cooldownMinutes,
          exercises: _pick(cooldowns, 2, equipmentNames, durationLabel: "30-45 seg"),
        ),
      ],
    );
  }
}
