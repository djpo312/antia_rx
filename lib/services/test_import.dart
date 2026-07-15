import 'package:flutter/material.dart';
import 'exercise_importer.dart';

class TestImport extends StatefulWidget {
  const TestImport({super.key});

  @override
  State<TestImport> createState() => _TestImportState();
}

class _TestImportState extends State<TestImport> {
  final importer = ExerciseImporter();

  @override
  void initState() {
    super.initState();

    importer.loadExercises().then((value) {
      debugPrint("Ejercicios encontrados: ${value.length}");

      debugPrint(value.first.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Probando Importador")));
  }
}
