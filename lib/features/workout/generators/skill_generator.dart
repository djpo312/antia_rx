import 'dart:math';

import '../../../database/app_database.dart';
import '../workout_model.dart';

class SkillGenerator {
  SkillGenerator({Random? random}) : random = random ?? Random();

  final Random random;

  WorkoutExerciseModel generate(Exercise exercise, {String? equipment}) {
    return WorkoutExerciseModel(
      name: exercise.name,
      equipment: equipment,
      duration: "${5 + random.nextInt(6)} min",
    );
  }
}
