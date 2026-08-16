import 'dart:math';

import '../../../database/app_database.dart';
import '../workout_model.dart';

class CooldownGenerator {
  final Random random = Random();

  WorkoutExerciseModel generate(Exercise exercise) {
    return WorkoutExerciseModel(
      name: exercise.name,
      duration: "${1 + random.nextInt(3)} min",
      notes: "Respiración y estiramiento",
    );
  }
}
