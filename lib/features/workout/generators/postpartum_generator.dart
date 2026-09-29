import 'dart:math';

import '../../../database/app_database.dart';
import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

/// Generador de "Gym Posparto": sesiones de 60 minutos de baja intensidad
/// pensadas para las primeras 0-3 semanas/meses posparto. A diferencia del
/// generador de CrossFit, no usa formatos de metcon (AMRAP, EMOM, For
/// Time...) — todo es series x repeticiones controladas, sin saltos, sin
/// levantamientos pesados y sin ejercicios de abdomen clásico (crunch/
/// sit-up) que puedan cargar la diástasis o el piso pélvico.
class PostpartumGenerator {
  PostpartumGenerator(this.repository, {int? seed})
    : random = seed != null ? Random(seed) : Random();

  final ExerciseRepository repository;
  final Random random;

  static const String categoryName = "Gym Posparto";
  static const int totalMinutes = 60;

  final Set<int> usedExercises = {};

  /// [repsLabel] es para ejercicios de series x repeticiones (va con
  /// [sets]); [durationLabel] es para sostenes/estiramientos por tiempo
  /// (sin series, para no repetir el dato dos veces en la tarjeta).
  List<WorkoutExerciseModel> _pick(
    List<Exercise> source,
    int amount,
    Map<int, String> equipmentNames, {
    String? sets,
    String? repsLabel,
    String? durationLabel,
    String? notes,
  }) {
    source.shuffle(random);

    final selected = <WorkoutExerciseModel>[];

    for (final exercise in source) {
      if (usedExercises.contains(exercise.id)) continue;

      usedExercises.add(exercise.id);

      final equipment = equipmentNames[exercise.equipmentId];

      selected.add(
        WorkoutExerciseModel(
          name: exercise.name,
          equipment: equipment,
          sets: sets,
          reps: repsLabel,
          duration: durationLabel,
          weight: equipment == "Dumbbell" ? "3-5lb (bien ligera)" : null,
          notes: notes,
        ),
      );

      if (selected.length == amount) break;
    }

    return selected;
  }

  Future<WorkoutModel> generate() async {
    usedExercises.clear();

    // Reparte los 60 minutos entre las ventanas, sin sección de metcon.
    final warmupMinutes = 12 + random.nextInt(4); // 12-15
    final coreMinutes = 15 + random.nextInt(4); // 15-18
    final strengthMinutes = 18 + random.nextInt(5); // 18-22
    final cooldownMinutes =
        totalMinutes - (warmupMinutes + coreMinutes + strengthMinutes);

    final equipmentNames = await repository.getEquipmentNames();

    final warmups = await repository.getWarmupExercisesForCategory(
      categoryName,
    );
    final core = await repository.getSkillExercisesForCategory(categoryName);
    final strength = await repository.getStrengthExercisesForCategory(
      categoryName,
    );
    final cooldowns = await repository.getCooldownExercisesForCategory(
      categoryName,
    );

    return WorkoutModel(
      title: "Gym Posparto del Día",
      type: "Gym Posparto",
      sections: [
        WorkoutSectionModel(
          name: "Calentamiento",
          subtitle: "Movilidad suave y respiración",
          durationMinutes: warmupMinutes,
          exercises: _pick(
            warmups,
            3,
            equipmentNames,
            sets: "2-3",
            repsLabel: "8-10",
            notes: "Sin dolor ni molestia. Si algo duele, se detiene.",
          ),
        ),

        WorkoutSectionModel(
          name: "Core y Piso Pélvico",
          subtitle: "Reconexión abdominal",
          durationMinutes: coreMinutes,
          exercises: _pick(
            core,
            3,
            equipmentNames,
            sets: "2-3",
            repsLabel: "8-10",
            notes: "Exhala en el esfuerzo, nunca aguantes el aire ni pujes.",
          ),
        ),

        WorkoutSectionModel(
          name: "Fuerza Funcional",
          subtitle: "Ligera · sin impacto",
          durationMinutes: strengthMinutes,
          exercises: _pick(
            strength,
            3,
            equipmentNames,
            sets: "2-3",
            repsLabel: "10-12",
          ),
        ),

        WorkoutSectionModel(
          name: "Enfriamiento",
          subtitle: "Estiramiento y respiración",
          durationMinutes: cooldownMinutes,
          exercises: _pick(
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
