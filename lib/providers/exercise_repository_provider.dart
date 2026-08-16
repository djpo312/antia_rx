import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/exercise_repository.dart';
import '../repositories/database_provider.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ExerciseRepository(database);
});
