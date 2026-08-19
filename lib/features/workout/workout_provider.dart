import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/exercise_repository_provider.dart';
import 'workout_generator.dart';
import 'workout_model.dart';

/// Generador libre: cada vez que se pide un WOD nuevo, sale distinto.
/// Lo usa la pantalla "Generador de WOD".
final workoutProvider = Provider<WorkoutGenerator>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);

  return WorkoutGenerator(repository);
});

/// Semilla determinística a partir del día de hoy: mismo día -> mismo
/// número, así el WOD del día no cambia si se recarga la app.
int _todaySeed() {
  final today = DateTime.now();
  return today.year * 10000 + today.month * 100 + today.day;
}

/// Entrenamiento del día: se genera una sola vez por fecha y se comparte
/// entre el Dashboard y la pantalla de CrossFit, para que ambos muestren
/// exactamente el mismo WOD mientras dure el día.
final dailyWorkoutProvider = FutureProvider<WorkoutModel>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  final generator = WorkoutGenerator(repository, seed: _todaySeed());

  return generator.generate();
});
