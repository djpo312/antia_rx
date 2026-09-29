import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

class AmrapGenerator {
  AmrapGenerator(this.repository, {Random? random}) : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();

    exercises.shuffle(random);

    final selected = exercises.take(4).toList();

    final workoutExercises = selected.map((e) {
      final weights = WeightSuggestion.forExercise(e.name);

      return WorkoutExerciseModel(
        name: e.name,
        equipment: equipmentNames[e.equipmentId],
        reps: (8 + random.nextInt(8)).toString(),
        weight: weights?.label,
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
