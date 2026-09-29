import 'dart:math';

import '../../../database/app_database.dart';
import '../workout_model.dart';
import 'weight_table.dart';

class StrengthGenerator {
  StrengthGenerator({Random? random}) : random = random ?? Random();

  final Random random;

  WorkoutExerciseModel generate(Exercise exercise, {String? equipment}) {
    final variance = (random.nextInt(21) - 10).toDouble(); // ±10 lb
    final weights = WeightSuggestion.forExercise(
      exercise.name,
      variance: variance,
    );

    return WorkoutExerciseModel(
      name: exercise.name,
      equipment: equipment,
      sets: "${3 + random.nextInt(3)}",
      reps: "${3 + random.nextInt(6)}",
      weight: weights?.label ?? "${65 + random.nextInt(21)}% 1RM",
    );
  }
}
