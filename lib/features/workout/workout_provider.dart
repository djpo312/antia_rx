import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/exercise_repository_provider.dart';
import 'workout_generator.dart';

final workoutProvider = Provider<WorkoutGenerator>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);

  return WorkoutGenerator(repository);
});
