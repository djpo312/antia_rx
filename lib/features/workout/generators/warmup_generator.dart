import 'dart:math';

import '../../../database/app_database.dart';
import '../workout_model.dart';

class WarmupGenerator {
  WarmupGenerator({Random? random}) : random = random ?? Random();

  final Random random;

  WorkoutExerciseModel generate(Exercise exercise, {String? equipment}) {
    return WorkoutExerciseModel(
      name: exercise.name,
      equipment: equipment,
      reps: "${10 + random.nextInt(11)}",
    );
  }
}
