import '../database/app_database.dart';

class ExerciseRepository {
  final AppDatabase database;

  ExerciseRepository(this.database);

  Future<List<Exercise>> getAll() {
    return database.getAllExercises();
  }

  Future<List<Exercise>> getByCategory(int categoryId) {
    return (database.select(
      database.exercises,
    )..where((e) => e.categoryId.equals(categoryId))).get();
  }

  Future<List<Exercise>> getByDifficulty(int difficultyId) {
    return (database.select(
      database.exercises,
    )..where((e) => e.difficultyId.equals(difficultyId))).get();
  }
}
