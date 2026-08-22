import '../../database/app_database.dart';
import 'csv_importer.dart';
import 'exercise_importer.dart';

class DatabaseSeed {
  final AppDatabase database;
  final CsvImporter importer = CsvImporter();

  DatabaseSeed(this.database);

  /// [forceReseedExercises] se pasa en true cuando `catalogVersion`
  /// (lib/core/app_version.dart) cambió respecto a lo guardado en el
  /// teléfono: significa que se agregaron/editaron ejercicios en el CSV
  /// y hay que reimportarlos aunque la tabla ya tenga datos, sin obligar
  /// al usuario a desinstalar la app para verlos.
  Future<void> initialize({bool forceReseedExercises = false}) async {
    print("🚀 Iniciando importación...");

    // Estas 4 son idempotentes (solo insertan lo que falte), así que
    // corren siempre: si se agrega una categoría/equipo nuevo al CSV
    // (ej. "Gym Posparto") aparece solo al abrir la app, sin desinstalar.
    await _importCategories();
    await _importEquipment();
    await _importDifficultyLevels();
    await _importMovementPatterns();

    if (forceReseedExercises) {
      print("🔄 Catálogo de ejercicios desactualizado, reimportando...");
      await database.deleteAllExercises();
    }

    if ((await database.getAllExercises()).isEmpty) {
      await ExerciseImporter(database).importExercises();
    }

    print("🎉 Base de datos inicializada");
  }

  Future<void> _importCategories() async {
    final rows = await importer.load("assets/catalog/categories.csv");

    for (int i = 1; i < rows.length; i++) {
      final name = rows[i][1].toString();

      if (await database.getCategoryByName(name) != null) continue;

      await database
          .into(database.categories)
          .insert(CategoriesCompanion.insert(name: name));
    }

    print("Categorías importadas");
  }

  Future<void> _importEquipment() async {
    final rows = await importer.load("assets/catalog/equipment.csv");

    for (int i = 1; i < rows.length; i++) {
      final name = rows[i][1].toString();

      if (await database.getEquipmentByName(name) != null) continue;

      await database
          .into(database.equipment)
          .insert(EquipmentCompanion.insert(name: name));
    }

    print("Equipamiento importado");
  }

  Future<void> _importDifficultyLevels() async {
    final rows = await importer.load("assets/catalog/difficulty_levels.csv");

    for (int i = 1; i < rows.length; i++) {
      final name = rows[i][1].toString();

      if (await database.getDifficultyByName(name) != null) continue;

      await database
          .into(database.difficultyLevels)
          .insert(DifficultyLevelsCompanion.insert(name: name));
    }

    print("Dificultades importadas");
  }

  Future<void> _importMovementPatterns() async {
    final rows = await importer.load("assets/catalog/movement_patterns.csv");

    for (int i = 1; i < rows.length; i++) {
      final name = rows[i][1].toString();

      if (await database.getMovementByName(name) != null) continue;

      await database
          .into(database.movementPatterns)
          .insert(MovementPatternsCompanion.insert(name: name));
    }

    print("Patrones importados");
  }
}
