import 'dart:convert';

import 'package:flutter/services.dart';

import '../database/app_database.dart';

class DatabaseInitializer {
  final AppDatabase database;

  DatabaseInitializer(this.database);

  Future<void> initializeExercises() async {
    final existing = await database.getAllExercises();

    if (existing.isNotEmpty) return;

    final jsonString = await rootBundle.loadString(
      'assets/data/exercises.json',
    );

    final List<dynamic> jsonData = json.decode(jsonString);

    for (final item in jsonData) {
      await database.insertExercise(
        ExercisesCompanion.insert(
          code: item["code"],
          name: item["name"],
          description: item["description"],
          categoryId: item["categoryId"],
          equipmentId: item["equipmentId"],
          difficultyId: item["difficultyId"],
          movementPatternId: item["movementPatternId"],
          instructions: item["instructions"],
          videoUrl: drift.Value(item["videoUrl"]),
          imageUrl: drift.Value(item["imageUrl"]),
        ),
      );
    }
  }
}
