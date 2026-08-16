import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

class ChipperGenerator {
  final ExerciseRepository repository;
  final Random random = Random();

  ChipperGenerator(this.repository);

  Future<WorkoutSectionModel> generate() async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    // Un Chipper "desgasta" una lista larga de movimientos, cada uno una vez.
    final exerciseCount = min(6 + random.nextInt(3), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final cap = [15, 18, 20, 25][random.nextInt(4)];

    final workoutExercises = selected.map((exercise) {
      return WorkoutExerciseModel(
        name: exercise.name,
        reps: (10 + random.nextInt(31)).toString(),
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "CHIPPER (cap $cap')",
      exercises: workoutExercises,
    );
  }
}
