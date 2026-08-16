import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

class AmrapGenerator {
  final ExerciseRepository repository;
  final Random random = Random();

  AmrapGenerator(this.repository);

  Future<WorkoutSectionModel> generate() async {
    final exercises = await repository.getWodExercises();

    exercises.shuffle();

    final selected = exercises.take(4).toList();

    final minutes = [8, 10, 12, 15, 18, 20][random.nextInt(6)];

    final workoutExercises = selected.map((e) {
      return WorkoutExerciseModel(
        name: e.name,
        reps: (8 + random.nextInt(8)).toString(),
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "AMRAP $minutes'",
      exercises: workoutExercises,
    );
  }
}
