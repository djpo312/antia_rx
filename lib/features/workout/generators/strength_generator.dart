import 'dart:math';

import '../../../database/app_database.dart';
import '../workout_model.dart';

class StrengthGenerator {
  final Random random = Random();

  WorkoutExerciseModel generate(Exercise exercise) {
    return WorkoutExerciseModel(
      name: exercise.name,
      sets: "${3 + random.nextInt(3)}",
      reps: "${3 + random.nextInt(6)}",
      weight: "${65 + random.nextInt(21)}%",
    );
  }
}
