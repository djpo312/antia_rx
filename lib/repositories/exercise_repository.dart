import '../database/app_database.dart';

class ExerciseRepository {
  final AppDatabase database;

  ExerciseRepository(this.database);

  Future<List<Exercise>> getAllExercises() {
    return database.getAllExercises();
  }

  Future<Exercise?> getExerciseById(int id) {
    return (database.select(
      database.exercises,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Exercise>> getWarmupExercises() {
    return (database.select(
      database.exercises,
    )..where((tbl) => tbl.isWarmup.equals(true))).get();
  }

  Future<List<Exercise>> getStrengthExercises() {
    return (database.select(
      database.exercises,
    )..where((tbl) => tbl.isStrength.equals(true))).get();
  }

  Future<List<Exercise>> getSkillExercises() {
    return (database.select(
      database.exercises,
    )..where((tbl) => tbl.isSkill.equals(true))).get();
  }

  Future<List<Exercise>> getWodExercises() {
    return (database.select(
      database.exercises,
    )..where((tbl) => tbl.isWod.equals(true))).get();
  }

  Future<List<Exercise>> getCooldownExercises() {
    return (database.select(
      database.exercises,
    )..where((tbl) => tbl.isCooldown.equals(true))).get();
  }
}
