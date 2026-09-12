import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

/// Escalera ascendente o descendente de reps (ej. 1-2-3-4-5-6-7-8-9-10),
/// el mismo esquema para todos los ejercicios de la ronda.
class LadderGenerator {
  LadderGenerator(this.repository, {Random? random})
    : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    final exerciseCount = min(2 + random.nextInt(2), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final top = 5 + random.nextInt(6); // escalera hasta 5-10
    final ascending = random.nextBool();

    final rungs = ascending
        ? List.generate(top, (i) => i + 1)
        : List.generate(top, (i) => top - i);

    final scheme = rungs.join("-");

    final workoutExercises = selected.map((exercise) {
      final weights = WeightSuggestion.forExercise(exercise.name);

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        reps: scheme,
        weight: weights?.label,
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "LADDER ${ascending ? '1-$top' : '$top-1'} (cap $minutes')",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
