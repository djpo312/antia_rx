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

  // --- Consultas filtradas por categoría, para secciones (como Gym
  // Posparto) que no deben mezclar ejercicios de CrossFit/Mobility. Las
  // consultas de arriba se dejan intactas para no arriesgar el generador
  // de CrossFit, que ya depende de que no filtren por categoría. ---

  Future<List<Exercise>> getWarmupExercisesForCategory(
    String categoryName,
  ) async {
    final category = await database.getCategoryByName(categoryName);
    if (category == null) return [];

    return (database.select(database.exercises)
          ..where((tbl) => tbl.categoryId.equals(category.id))
          ..where((tbl) => tbl.isWarmup.equals(true)))
        .get();
  }

  Future<List<Exercise>> getSkillExercisesForCategory(
    String categoryName,
  ) async {
    final category = await database.getCategoryByName(categoryName);
    if (category == null) return [];

    return (database.select(database.exercises)
          ..where((tbl) => tbl.categoryId.equals(category.id))
          ..where((tbl) => tbl.isSkill.equals(true)))
        .get();
  }

  Future<List<Exercise>> getStrengthExercisesForCategory(
    String categoryName,
  ) async {
    final category = await database.getCategoryByName(categoryName);
    if (category == null) return [];

    return (database.select(database.exercises)
          ..where((tbl) => tbl.categoryId.equals(category.id))
          ..where((tbl) => tbl.isStrength.equals(true)))
        .get();
  }

  Future<List<Exercise>> getCooldownExercisesForCategory(
    String categoryName,
  ) async {
    final category = await database.getCategoryByName(categoryName);
    if (category == null) return [];

    return (database.select(database.exercises)
          ..where((tbl) => tbl.categoryId.equals(category.id))
          ..where((tbl) => tbl.isCooldown.equals(true)))
        .get();
  }

  /// Mapa id -> nombre del equipo (Barbell, Dumbbell, Kettlebell, ...),
  /// para mostrar un ícono por tipo de equipo en cada ejercicio.
  Future<Map<int, String>> getEquipmentNames() async {
    final rows = await database.select(database.equipment).get();
    return {for (final row in rows) row.id: row.name};
  }
}
