import '../app_database.dart';

class ExerciseRepository {
  final AppDatabase database;

  ExerciseRepository(this.database);

  Future<List<Exercise>> getAllExercises() {
    return database.select(database.exercises).get();
  }

  Future<int> addExercise(ExercisesCompanion exercise) {
    return database.into(database.exercises).insert(exercise);
  }

  Future<void> deleteAll() async {
    await database.delete(database.exercises).go();
  }
}
