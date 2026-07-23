import 'package:flutter/material.dart';

import 'exercise_list_item.dart';

class ExerciseDetailPage extends StatelessWidget {
  final ExerciseListItem exercise;

  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.fitness_center, size: 90),

            const SizedBox(height: 20),

            Text(
              exercise.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            Text(
              exercise.code,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(Icons.category),
                title: const Text("Categoría"),
                subtitle: Text(exercise.category),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.fitness_center),
                title: const Text("Equipo"),
                subtitle: Text(exercise.equipment),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text("Dificultad"),
                subtitle: Text(exercise.difficulty),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.accessibility_new),
                title: const Text("Patrón de movimiento"),
                subtitle: Text(exercise.movement),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Descripción",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 10),

            Text(exercise.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
