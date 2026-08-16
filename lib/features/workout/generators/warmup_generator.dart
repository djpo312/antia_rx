import 'dart:math';

import '../../../database/app_database.dart';
import '../workout_model.dart';

class WarmupGenerator {
  final Random random = Random();

  WorkoutExerciseModel generate(Exercise exercise) {
    return WorkoutExerciseModel(
      name: exercise.name,
      reps: "${10 + random.nextInt(11)}",
    );
  }
}
