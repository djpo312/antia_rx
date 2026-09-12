import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/exercise_repository_provider.dart';
import 'generators/gym_generator.dart';
import 'generators/postpartum_generator.dart';
import 'workout_generator.dart';
import 'workout_model.dart';

/// Generador libre: cada vez que se pide un WOD nuevo, sale distinto.
/// Lo usa la pantalla "Generador de WOD".
final workoutProvider = Provider<WorkoutGenerator>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);

  return WorkoutGenerator(repository);
});

/// Semilla determinística a partir de una fecha: mismo día -> mismo
/// número, así el WOD de ese día no cambia si se recarga la app. Público
/// para poder regenerar (de forma reproducible) el WOD de una fecha
/// pasada, por ejemplo al abrir un favorito guardado.
int dateSeed(DateTime date) => date.year * 10000 + date.month * 100 + date.day;

int _todaySeed() => dateSeed(DateTime.now());

/// Entrenamiento del día: se genera una sola vez por fecha y se comparte
/// entre el Dashboard y la pantalla de CrossFit, para que ambos muestren
/// exactamente el mismo WOD mientras dure el día.
final dailyWorkoutProvider = FutureProvider<WorkoutModel>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  final generator = WorkoutGenerator(repository, seed: _todaySeed());

  return generator.generate();
});

/// Igual que [dailyWorkoutProvider] pero para la sesión de Gym Posparto
/// (misma fecha, generador distinto: sin metcon, todo controlado).
final dailyPostpartumWorkoutProvider = FutureProvider<WorkoutModel>((
  ref,
) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  final generator = PostpartumGenerator(repository, seed: _todaySeed());

  return generator.generate();
});

/// Igual que [dailyWorkoutProvider] pero para la sesión de Gimnasio
/// (misma fecha, generador de fuerza/musculación sin metcon).
final dailyGymWorkoutProvider = FutureProvider<WorkoutModel>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  final generator = GymGenerator(repository, seed: _todaySeed());

  return generator.generate();
});
