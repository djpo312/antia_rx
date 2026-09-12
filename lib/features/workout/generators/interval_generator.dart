import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

/// Intervalos de trabajo/descanso fijos (ej. 3 rondas de 3' on / 1' off),
/// distinto del EMOM porque el bloque de trabajo dura varios minutos
/// seguidos en vez de reiniciar cada minuto.
class IntervalGenerator {
  IntervalGenerator(this.repository, {Random? random})
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

    final workMinutes = 2 + random.nextInt(3); // 2-4' de trabajo
    final restMinutes = 1 + random.nextInt(2); // 1-2' de descanso
    final rounds = max(2, (minutes / (workMinutes + restMinutes)).round());

    final workoutExercises = selected.map((exercise) {
      final weights = WeightSuggestion.forExercise(exercise.name);

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        duration: "Máx. reps en $workMinutes'",
        weight: weights?.label,
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "$rounds Intervalos ($workMinutes' on / $restMinutes' off)",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
