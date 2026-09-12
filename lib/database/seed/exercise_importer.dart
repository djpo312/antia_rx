import '../app_database.dart';
import 'csv_importer.dart';
import 'package:drift/drift.dart';

class ExerciseImporter {
  final AppDatabase database;
  final CsvImporter importer = CsvImporter();

  ExerciseImporter(this.database);

  bool _toBool(dynamic value) {
    final text = value.toString().trim().toLowerCase();

    return text == "true" || text == "1" || text == "si" || text == "sí";
  }

  Future<void> importExercises() async {
    print("📦 Importando ejercicios...");

    final rows = await importer.load("assets/catalog/exercises.csv");

    // Se resuelven categoría/equipo/dificultad/movimiento con un solo
    // select por tabla (en vez de 4 selects por fila de ejercicio) y se
    // insertan todos los ejercicios en un único batch: además de ser
    // mucho más rápido, evita el problema visto en la web donde muchos
    // inserts individuales seguidos contra IndexedDB podían dejar la
    // tabla de ejercicios sin datos visibles para las lecturas
    // posteriores (WOD generado, catálogo de ejercicios) aunque la
    // importación "terminara" sin error.
    final categoriesByName = {
      for (final c in await database.select(database.categories).get())
        c.name: c,
    };
    final equipmentByName = {
      for (final e in await database.select(database.equipment).get())
        e.name: e,
    };
    final difficultyByName = {
      for (final d in await database.select(database.difficultyLevels).get())
        d.name: d,
    };
    final movementByName = {
      for (final m in await database.select(database.movementPatterns).get())
        m.name: m,
    };

    final toInsert = <ExercisesCompanion>[];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      final categoryName = row[3].toString();
      final equipmentName = row[4].toString();
      final difficultyName = row[5].toString();
      final movementName = row[6].toString();

      final category = categoriesByName[categoryName];
      final equipment = equipmentByName[equipmentName];
      final difficulty = difficultyByName[difficultyName];
      final movement = movementByName[movementName];

      if (category == null) {
        print("❌ Categoría no encontrada: $categoryName");
      }
      if (equipment == null) {
        print("❌ Equipamiento no encontrado: $equipmentName");
      }
      if (difficulty == null) {
        print("❌ Dificultad no encontrada: $difficultyName");
      }
      if (movement == null) {
        print("❌ Movimiento no encontrado: $movementName");
      }

      if (category == null ||
          equipment == null ||
          difficulty == null ||
          movement == null) {
        continue;
      }

      toInsert.add(
        ExercisesCompanion.insert(
          code: row[0].toString(),
          name: row[1].toString(),
          description: row[2].toString(),
          categoryId: category.id,
          equipmentId: equipment.id,
          difficultyId: difficulty.id,
          movementPatternId: movement.id,
          instructions: "",
          videoUrl: const Value(null),
          imageUrl: const Value(null),
          isWarmup: Value(_toBool(row[7])),
          isMobility: Value(_toBool(row[8])),
          isStrength: Value(_toBool(row[9])),
          isSkill: Value(_toBool(row[10])),
          isWod: Value(_toBool(row[11])),
          isAccessory: Value(_toBool(row[12])),
          isCooldown: Value(_toBool(row[13])),
        ),
      );
    }

    if (toInsert.isNotEmpty) {
      await database.batch((batch) {
        batch.insertAll(
          database.exercises,
          toInsert,
          mode: InsertMode.insertOrIgnore,
        );
      });
    }

    print("✅ Ejercicios importados");
  }
}
