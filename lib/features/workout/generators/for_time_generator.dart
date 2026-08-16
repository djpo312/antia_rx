import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

class ForTimeGenerator {
  final ExerciseRepository repository;
  final Random random = Random();

  ForTimeGenerator(this.repository);

  Future<WorkoutSectionModel> generate(int minutes) async {
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
      return WorkoutExerciseModel(name: exercise.name, reps: scheme.join("-"));
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "FOR TIME (cap $minutes')",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
