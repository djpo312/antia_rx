import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

class ChipperGenerator {
  ChipperGenerator(this.repository, {Random? random}) : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    // Un Chipper "desgasta" una lista larga de movimientos, cada uno una vez.
    final exerciseCount = min(6 + random.nextInt(3), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final workoutExercises = selected.map((exercise) {
      final weights = WeightSuggestion.forExercise(exercise.name);

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        reps: (10 + random.nextInt(31)).toString(),
        weight: weights?.label,
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
