import 'dart:convert';
import 'package:flutter/services.dart';

class ExerciseImporter {
  Future<List<Map<String, dynamic>>> loadExercises() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/exercises.json',
    );

    final List<dynamic> data = json.decode(jsonString);

    return data.cast<Map<String, dynamic>>();
  }
}
