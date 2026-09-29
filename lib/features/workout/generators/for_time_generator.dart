import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

class ForTimeGenerator {
  ForTimeGenerator(this.repository, {Random? random}) : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    final exerciseCount = min(2 + random.nextInt(2), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    // Esquemas clásicos de reps descendentes para "For Time"
    final schemes = [
      [21, 15, 9],
      [15, 12, 9],
      [50, 40, 30, 20, 10],
      [10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
    ];
    final scheme = schemes[random.nextInt(schemes.length)];

    final workoutExercises = selected.map((exercise) {
      final weights = WeightSuggestion.forExercise(exercise.name);

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        reps: scheme.join("-"),
        weight: weights?.label,
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "FOR TIME (cap $minutes')",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
