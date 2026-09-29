import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

/// Tabata clásico: 8 rondas de 20" de trabajo / 10" de descanso (4 min por
/// bloque). Si el tiempo del día alcanza para más de un bloque, se repite
/// alternando entre 1 o 2 movimientos hasta llenar el cupo.
class TabataGenerator {
  TabataGenerator(this.repository, {Random? random})
    : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    final exerciseCount = min(1 + random.nextInt(2), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final workoutExercises = selected.map((exercise) {
      final weights = WeightSuggestion.forExercise(exercise.name);

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        duration: "Máx. reps en 20\"",
        weight: weights?.label,
        notes: "8 rondas · 20\" on / 10\" off",
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "TABATA (bloques de 4' hasta completar $minutes')",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
