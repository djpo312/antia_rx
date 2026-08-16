import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

class RoundsGenerator {
  final ExerciseRepository repository;
  final Random random = Random();

  RoundsGenerator(this.repository);

  Future<WorkoutSectionModel> generate(int minutes) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    final exerciseCount = min(3 + random.nextInt(2), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final rounds = 3 + random.nextInt(3);

    final workoutExercises = selected.map((exercise) {
      return WorkoutExerciseModel(
        name: exercise.name,
        reps: (8 + random.nextInt(13)).toString(),
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
