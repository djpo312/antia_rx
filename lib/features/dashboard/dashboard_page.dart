import 'package:flutter/material.dart';

import '../../data/sample_workouts.dart';
import '../crossfit/crossfit_page.dart';
import '../gym/gym_page.dart';
import '../hyrox/hyrox_page.dart';
import '../running/running_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final crossfitWorkout = sampleWorkouts.first;

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

            _menuCard(
              context,
              Icons.fitness_center,
              "CrossFit",
              Colors.orange,
              const CrossfitPage(),
            ),

            _menuCard(
              context,
              Icons.directions_run,
              "Running",
              Colors.green,
              const RunningPage(),
            ),

            _menuCard(
              context,
              Icons.local_fire_department,
              "Hyrox",
              Colors.red,
              const HyroxPage(),
            ),

            _menuCard(
              context,
              Icons.sports_gymnastics,
              "Gimnasio",
              Colors.blue,
              const GymPage(),
            ),

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
                        subtitle: Text(
                          "${exercise.sets} series de ${exercise.reps} repeticiones",
                        ),
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
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
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

  Widget _menuCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    Widget page,
  ) {
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
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
