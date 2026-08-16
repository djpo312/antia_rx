import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

class AmrapGenerator {
  final ExerciseRepository repository;
  final Random random = Random();

  AmrapGenerator(this.repository);

  Future<WorkoutSectionModel> generate(int minutes) async {
    final exercises = await repository.getWodExercises();

    exercises.shuffle(random);

    final selected = exercises.take(4).toList();

    final workoutExercises = selected.map((e) {
      return WorkoutExerciseModel(
        name: e.name,
        reps: (8 + random.nextInt(8)).toString(),
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "AMRAP $minutes'",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
