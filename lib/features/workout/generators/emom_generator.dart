import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';

class EmomGenerator {
  final ExerciseRepository repository;
  final Random random = Random();

  EmomGenerator(this.repository);

  Future<WorkoutSectionModel> generate() async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    // EMOM suele rotar entre 2 o 3 movimientos, uno por minuto.
    final exerciseCount = min(2 + random.nextInt(2), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final minutes = [10, 12, 14, 16, 20][random.nextInt(5)];

    final workoutExercises = selected.asMap().entries.map((entry) {
      final index = entry.key;
      final exercise = entry.value;

      return WorkoutExerciseModel(
        name: exercise.name,
        reps: (8 + random.nextInt(10)).toString(),
        notes: selected.length == 1
            ? "Cada minuto"
            : "Minuto ${index + 1} de cada ${selected.length}",
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "EMOM $minutes'",
      exercises: workoutExercises,
    );
  }
}
