import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/exercises/exercise_list_item.dart';
import '../database/app_database.dart';
import 'database_provider.dart';
import 'search_provider.dart';
import 'category_provider.dart';

final exercisesProvider = FutureProvider<List<ExerciseListItem>>((ref) async {
  final db = ref.watch(databaseProvider);

  final search = ref.watch(searchProvider).toLowerCase();
  final category = ref.watch(categoryProvider);

  final exercises = await db.getExercises();

  return exercises.where((exercise) {
    final matchesSearch =
        search.isEmpty ||
        exercise.name.toLowerCase().contains(search) ||
        exercise.description.toLowerCase().contains(search) ||
        exercise.code.toLowerCase().contains(search);

    // En el siguiente paso activaremos este filtro
    final matchesCategory =
        category == "Todas" || exercise.category == category;

    return matchesSearch && matchesCategory;
  }).toList();
});
