import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

/// Buy-in / Cash-out: un movimiento grande al inicio y al final (el mismo),
/// con un AMRAP corto de 2 ejercicios en el medio.
class BuyInCashOutGenerator {
  BuyInCashOutGenerator(this.repository, {Random? random})
    : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    if (exercises.isEmpty) {
      return WorkoutSectionModel(
        name: "WOD",
        subtitle: "BUY-IN / AMRAP / CASH-OUT (cap $minutes')",
        durationMinutes: minutes,
        exercises: const [],
      );
    }

    final bookend = exercises.first;
    final middle = exercises
        .skip(1)
        .take(min(2, max(0, exercises.length - 1)))
        .toList();

    final bookendReps = (20 + random.nextInt(31)).toString();
    final bookendWeights = WeightSuggestion.forExercise(bookend.name);

    final middleExercises = middle.map((exercise) {
      final weights = WeightSuggestion.forExercise(exercise.name);

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        reps: (8 + random.nextInt(8)).toString(),
        weight: weights?.label,
      );
    });

    final workoutExercises = [
      WorkoutExerciseModel(
        name: bookend.name,
        equipment: equipmentNames[bookend.equipmentId],
        reps: bookendReps,
        weight: bookendWeights?.label,
        notes: "Buy-in",
      ),
      ...middleExercises,
      WorkoutExerciseModel(
        name: bookend.name,
        equipment: equipmentNames[bookend.equipmentId],
        reps: bookendReps,
        weight: bookendWeights?.label,
        notes: "Cash-out",
      ),
    ];

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "BUY-IN / AMRAP / CASH-OUT (cap $minutes')",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
