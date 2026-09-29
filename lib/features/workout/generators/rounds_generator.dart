import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

class RoundsGenerator {
  RoundsGenerator(this.repository, {Random? random}) : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    final exerciseCount = min(3 + random.nextInt(2), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final rounds = 3 + random.nextInt(3);

    final workoutExercises = selected.map((exercise) {
      final weights = WeightSuggestion.forExercise(exercise.name);

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        reps: (8 + random.nextInt(13)).toString(),
        weight: weights?.label,
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "$rounds Rondas (cap $minutes')",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
