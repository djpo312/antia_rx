import 'dart:math';

import '../../../database/app_database.dart';
import '../workout_model.dart';

class SkillGenerator {
  final Random random = Random();

  WorkoutExerciseModel generate(Exercise exercise) {
    return WorkoutExerciseModel(
      name: exercise.name,
      duration: "${5 + random.nextInt(6)} min",
    );
  }
}
