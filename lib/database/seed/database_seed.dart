import '../../database/app_database.dart';
import 'csv_importer.dart';

class DatabaseSeed {
  final AppDatabase database;
  final CsvImporter importer = CsvImporter();

  DatabaseSeed(this.database);

  Future<void> initialize() async {
    final exercises = await database.getAllExercises();

    if (exercises.isNotEmpty) {
      print("✅ Base de datos ya inicializada");
      return;
    }

    print("🚀 Iniciando importación...");

    await _importCategories();
    await _importEquipment();
    await _importDifficultyLevels();
    await _importMovementPatterns();

    print("✅ Catálogos importados");
  }

  Future<void> _importCategories() async {
    final rows = await importer.load("assets/catalog/categories.csv");

    for (int i = 1; i < rows.length; i++) {
      await database
          .into(database.categories)
          .insert(CategoriesCompanion.insert(name: rows[i][0].toString()));
    }

    print("Categorías importadas");
  }

  Future<void> _importEquipment() async {
    final rows = await importer.load("assets/catalog/equipment.csv");

    for (int i = 1; i < rows.length; i++) {
      await database
          .into(database.equipment)
          .insert(EquipmentCompanion.insert(name: rows[i][0].toString()));
    }

    print("Equipamiento importado");
  }

  Future<void> _importDifficultyLevels() async {
    final rows = await importer.load("assets/catalog/difficulty_levels.csv");

    for (int i = 1; i < rows.length; i++) {
      await database
          .into(database.difficultyLevels)
          .insert(
            DifficultyLevelsCompanion.insert(name: rows[i][0].toString()),
          );
    }

    print("Dificultades importadas");
  }

  Future<void> _importMovementPatterns() async {
    final rows = await importer.load("assets/catalog/movement_patterns.csv");

    for (int i = 1; i < rows.length; i++) {
      await database
          .into(database.movementPatterns)
          .insert(
            MovementPatternsCompanion.insert(name: rows[i][0].toString()),
          );
    }

    print("Patrones importados");
  }
}
