import 'dart:math';

import '../../../repositories/exercise_repository.dart';
import '../workout_model.dart';
import 'weight_table.dart';

class EmomGenerator {
  EmomGenerator(this.repository, {Random? random}) : random = random ?? Random();

  final ExerciseRepository repository;
  final Random random;

  Future<WorkoutSectionModel> generate(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final exercises = await repository.getWodExercises();
    exercises.shuffle(random);

    // EMOM suele rotar entre 2 o 3 movimientos, uno por minuto (o cada
    // 2/3 minutos si el bloque es E2MOM/E3MOM, para movimientos más
    // pesados o técnicos).
    final exerciseCount = min(2 + random.nextInt(2), exercises.length);
    final selected = exercises.take(exerciseCount).toList();

    final intervalMinutes = 1 + random.nextInt(3); // 1, 2 o 3
    final label = intervalMinutes == 1 ? "EMOM" : "E${intervalMinutes}MOM";

    final workoutExercises = selected.asMap().entries.map((entry) {
      final index = entry.key;
      final exercise = entry.value;
      final weights = WeightSuggestion.forExercise(exercise.name);

      final rotationNote = selected.length == 1
          ? "Cada $intervalMinutes'"
          : "Bloque ${index + 1} de cada ${selected.length}, cada $intervalMinutes'";

      return WorkoutExerciseModel(
        name: exercise.name,
        equipment: equipmentNames[exercise.equipmentId],
        reps: (8 + random.nextInt(10)).toString(),
        weight: weights?.label,
        notes: rotationNote,
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle: "$label $minutes'",
      durationMinutes: minutes,
      exercises: workoutExercises,
    );
  }
}
