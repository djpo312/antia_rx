import 'package:flutter/material.dart';
import '../../data/sample_workouts.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vida Asistente")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hola Danny 👋",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "¿Qué quieres entrenar hoy?",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 25),

            _menuCard(Icons.fitness_center, "CrossFit", Colors.orange),

            _menuCard(Icons.directions_run, "Running", Colors.green),

            _menuCard(Icons.local_fire_department, "Hyrox", Colors.red),

            _menuCard(Icons.sports_gymnastics, "Gimnasio", Colors.blue),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🔥 WOD del día",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      crossfitWorkout.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Divider(),

                    ...crossfitWorkout.exercises.map(
                      (exercise) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(exercise.name),
                        subtitle: Text(exercise.description),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Resumen semanal",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 15),

                    Text("🏋 Entrenamientos: 0"),

                    Text("🔥 Calorías: 0"),

                    Text("⏱ Tiempo: 0 min"),

                    Text("🏆 PR nuevos: 0"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(IconData icon, String title, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }
}
