import '../database/app_database.dart';

class ExerciseRepository {
  final AppDatabase database;

  ExerciseRepository(this.database);

  Future<List<Exercise>> getAllExercises() {
    return database.getAllExercises();
  }

  Future<Exercise?> getExerciseById(int id) async {
    return (database.select(
      database.exercises,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}
