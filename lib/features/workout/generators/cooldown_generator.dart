import 'dart:math';

import '../../../database/app_database.dart';
import '../workout_model.dart';

class CooldownGenerator {
  CooldownGenerator({Random? random}) : random = random ?? Random();

  final Random random;

  WorkoutExerciseModel generate(Exercise exercise, {String? equipment}) {
    return WorkoutExerciseModel(
      name: exercise.name,
      equipment: equipment,
      duration: "${1 + random.nextInt(3)} min",
      notes: "Respiración y estiramiento",
    );
  }
}
