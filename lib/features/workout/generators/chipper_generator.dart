import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

class ChipperGenerator {
  final ExerciseRepository repository;
  final Random random = Random();

  ChipperGenerator(this.repository);

  Future<WorkoutSectionModel> generate(int minutes) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    // Un Chipper "desgasta" una lista larga de movimientos, cada uno una vez.
    final exerciseCount = min(6 + random.nextInt(3), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final workoutExercises = selected.map((exercise) {
      return WorkoutExerciseModel(
        name: exercise.name,
        reps: (10 + random.nextInt(31)).toString(),
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "CHIPPER (cap $minutes')",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
