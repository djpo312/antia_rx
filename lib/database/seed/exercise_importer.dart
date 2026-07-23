import '../app_database.dart';
import 'csv_importer.dart';
import 'package:drift/drift.dart';

class ExerciseImporter {
  final AppDatabase database;
  final CsvImporter importer = CsvImporter();

  ExerciseImporter(this.database);

  bool _toBool(dynamic value) {
    return value.toString().toLowerCase() == "true";
  }

  Future<void> importExercises() async {
    print("📦 Importando ejercicios...");

    final rows = await importer.load("assets/catalog/exercises.csv");

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      print("=================================");
      print(row);
      print("Categoria : '${row[3]}'");
      print("Equipo    : '${row[4]}'");
      print("Dificultad: '${row[5]}'");
      print("Movimiento: '${row[6]}'");

      final category = await database.getCategoryByName(row[3].toString());
      final equipment = await database.getEquipmentByName(row[4].toString());
      final difficulty = await database.getDifficultyByName(row[5].toString());
      final movement = await database.getMovementByName(row[6].toString());

      if (category == null) {
        print("❌ Categoría no encontrada: ${row[3]}");
      }

      if (equipment == null) {
        print("❌ Equipamiento no encontrado: ${row[4]}");
      }

      if (difficulty == null) {
        print("❌ Dificultad no encontrada: ${row[5]}");
      }

      if (movement == null) {
        print("❌ Movimiento no encontrado: ${row[6]}");
      }

      if (category == null ||
          equipment == null ||
          difficulty == null ||
          movement == null) {
        continue;
      }

      await database.insertExercise(
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

    print("✅ Ejercicios importados");
  }
}
