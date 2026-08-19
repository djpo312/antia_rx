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

    if ((await database.select(database.categories).get()).isEmpty) {
      await _importCategories();
    }

    if ((await database.select(database.equipment).get()).isEmpty) {
      await _importEquipment();
    }

    if ((await database.select(database.difficultyLevels).get()).isEmpty) {
      await _importDifficultyLevels();
    }

    if ((await database.select(database.movementPatterns).get()).isEmpty) {
      await _importMovementPatterns();
    }

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
    print("Leyendo categories.csv...");

    final rows = await importer.load("assets/catalog/categories.csv");

    print(rows);

    for (int i = 1; i < rows.length; i++) {
      await database
          .into(database.categories)
          .insert(CategoriesCompanion.insert(name: rows[i][1].toString()));
    }

    print("Categorías importadas");
  }

  Future<void> _importEquipment() async {
    final rows = await importer.load("assets/catalog/equipment.csv");

    print("===== EQUIPMENT CSV =====");
    print(rows);

    for (int i = 1; i < rows.length; i++) {
      print("Insertando: ${rows[i][1]}");

      await database
          .into(database.equipment)
          .insert(EquipmentCompanion.insert(name: rows[i][1].toString()));
    }

    print("Equipamiento importado");
  }

  Future<void> _importDifficultyLevels() async {
    final rows = await importer.load("assets/catalog/difficulty_levels.csv");

    for (int i = 1; i < rows.length; i++) {
      await database
          .into(database.difficultyLevels)
          .insert(
            DifficultyLevelsCompanion.insert(name: rows[i][1].toString()),
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
            MovementPatternsCompanion.insert(name: rows[i][1].toString()),
          );
    }

    print("Patrones importados");
  }
}
