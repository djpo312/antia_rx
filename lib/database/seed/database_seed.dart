import 'package:drift/drift.dart';

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
    // Se hacen en un solo batch cada una (en vez de un insert awaited por
    // fila) porque en la web, muchos inserts individuales seguidos contra
    // IndexedDB podían dejar la escritura sin confirmar a tiempo para la
    // siguiente lectura (a veces hasta colgaba la importación).
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
    final existing = (await database.select(database.categories).get())
        .map((c) => c.name)
        .toSet();

    final toInsert = <CategoriesCompanion>[];
    for (int i = 1; i < rows.length; i++) {
      final name = rows[i][1].toString();
      if (existing.add(name)) {
        toInsert.add(CategoriesCompanion.insert(name: name));
      }
    }

    if (toInsert.isNotEmpty) {
      await database.batch((batch) {
        batch.insertAll(
          database.categories,
          toInsert,
          mode: InsertMode.insertOrIgnore,
        );
      });
    }

    print("Categorías importadas");
  }

  Future<void> _importEquipment() async {
    final rows = await importer.load("assets/catalog/equipment.csv");
    final existing = (await database.select(database.equipment).get())
        .map((e) => e.name)
        .toSet();

    final toInsert = <EquipmentCompanion>[];
    for (int i = 1; i < rows.length; i++) {
      final name = rows[i][1].toString();
      if (existing.add(name)) {
        toInsert.add(EquipmentCompanion.insert(name: name));
      }
    }

    if (toInsert.isNotEmpty) {
      await database.batch((batch) {
        batch.insertAll(
          database.equipment,
          toInsert,
          mode: InsertMode.insertOrIgnore,
        );
      });
    }

    print("Equipamiento importado");
  }

  Future<void> _importDifficultyLevels() async {
    final rows = await importer.load("assets/catalog/difficulty_levels.csv");
    final existing = (await database.select(database.difficultyLevels).get())
        .map((d) => d.name)
        .toSet();

    final toInsert = <DifficultyLevelsCompanion>[];
    for (int i = 1; i < rows.length; i++) {
      final name = rows[i][1].toString();
      if (existing.add(name)) {
        toInsert.add(DifficultyLevelsCompanion.insert(name: name));
      }
    }

    if (toInsert.isNotEmpty) {
      await database.batch((batch) {
        batch.insertAll(
          database.difficultyLevels,
          toInsert,
          mode: InsertMode.insertOrIgnore,
        );
      });
    }

    print("Dificultades importadas");
  }

  Future<void> _importMovementPatterns() async {
    final rows = await importer.load("assets/catalog/movement_patterns.csv");
    final existing = (await database.select(database.movementPatterns).get())
        .map((m) => m.name)
        .toSet();

    final toInsert = <MovementPatternsCompanion>[];
    for (int i = 1; i < rows.length; i++) {
      final name = rows[i][1].toString();
      if (existing.add(name)) {
        toInsert.add(MovementPatternsCompanion.insert(name: name));
      }
    }

    if (toInsert.isNotEmpty) {
      await database.batch((batch) {
        batch.insertAll(
          database.movementPatterns,
          toInsert,
          mode: InsertMode.insertOrIgnore,
        );
      });
    }

    print("Patrones importados");
  }
}
