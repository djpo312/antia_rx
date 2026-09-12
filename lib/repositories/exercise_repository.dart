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

  // El generador de CrossFit siempre saca ejercicios de este pool: la
  // propia categoría CrossFit, más Mobility (para que Warm Up/Cool Down
  // tengan estiramientos). Ninguna otra categoría (Gym Posparto, Gym,
  // Running, Hyrox...) debe colarse acá aunque comparta una bandera como
  // isWarmup/isStrength: sin este filtro, un ejercicio de Gym Posparto
  // marcado isWarmup terminaba apareciendo en un WOD de CrossFit.
  static const _crossfitPoolCategories = ['CrossFit', 'Mobility'];

  Future<List<int>> _crossfitPoolCategoryIds() async {
    final categories = await (database.select(
      database.categories,
    )..where((tbl) => tbl.name.isIn(_crossfitPoolCategories))).get();

    return categories.map((c) => c.id).toList();
  }

  Future<List<Exercise>> getWarmupExercises() async {
    final categoryIds = await _crossfitPoolCategoryIds();

    return (database.select(database.exercises)
          ..where((tbl) => tbl.isWarmup.equals(true))
          ..where((tbl) => tbl.categoryId.isIn(categoryIds)))
        .get();
  }

  Future<List<Exercise>> getStrengthExercises() async {
    final categoryIds = await _crossfitPoolCategoryIds();

    return (database.select(database.exercises)
          ..where((tbl) => tbl.isStrength.equals(true))
          ..where((tbl) => tbl.categoryId.isIn(categoryIds)))
        .get();
  }

  Future<List<Exercise>> getSkillExercises() async {
    final categoryIds = await _crossfitPoolCategoryIds();

    return (database.select(database.exercises)
          ..where((tbl) => tbl.isSkill.equals(true))
          ..where((tbl) => tbl.categoryId.isIn(categoryIds)))
        .get();
  }

  Future<List<Exercise>> getWodExercises() async {
    final categoryIds = await _crossfitPoolCategoryIds();

    return (database.select(database.exercises)
          ..where((tbl) => tbl.isWod.equals(true))
          ..where((tbl) => tbl.categoryId.isIn(categoryIds)))
        .get();
  }

  Future<List<Exercise>> getCooldownExercises() async {
    final categoryIds = await _crossfitPoolCategoryIds();

    return (database.select(database.exercises)
          ..where((tbl) => tbl.isCooldown.equals(true))
          ..where((tbl) => tbl.categoryId.isIn(categoryIds)))
        .get();
  }

  // --- Consultas filtradas por categoría, para secciones (como Gym
  // Posparto o Gimnasio) que no deben mezclar ejercicios de otras
  // categorías. ---

  Future<List<Exercise>> getAccessoryExercisesForCategory(
    String categoryName,
  ) async {
    final category = await database.getCategoryByName(categoryName);
    if (category == null) return [];

    return (database.select(database.exercises)
          ..where((tbl) => tbl.categoryId.equals(category.id))
          ..where((tbl) => tbl.isAccessory.equals(true)))
        .get();
  }

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
