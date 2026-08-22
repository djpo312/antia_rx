import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

/// Death By: en el minuto 1 se hace 1 rep, en el minuto 2 se hacen 2 reps,
/// y así sucesivamente hasta que ya no se complete el minuto. Suele ser
/// un solo movimiento, a veces dos alternados.
class DeathByGenerator {
  DeathByGenerator(this.repository, {Random? random})
    : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    final exerciseCount = min(1 + random.nextInt(2), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final workoutExercises = selected.map((exercise) {
      final weights = WeightSuggestion.forExercise(exercise.name);

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        duration: "1 rep, +1 cada minuto",
        weight: weights?.label,
        notes: "Termina cuando no completes el minuto",
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "DEATH BY (cap $minutes')",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
