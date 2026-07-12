import 'package:flutter/material.dart';
import '../../core/widgets/workout_timer.dart';

class CrossfitPage extends StatelessWidget {
  const CrossfitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CrossFit")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "🏋️ WOD del Día",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _section("🔥 Warm Up", [
            "400 m Run",
            "20 Air Squats",
            "15 PVC Pass Through",
          ]),

          _section("🏋️ Strength", ["Back Squat", "5 x 5 @80%"]),

          _section("⚡ Metcon", [
            "For Time",
            "",
            "21-15-9",
            "",
            "Thrusters",
            "Pull-ups",
          ]),

          const SizedBox(height: 30),

          const WorkoutTimer(),

          const SizedBox(height: 15),

          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            label: const Text("Guardar favorito"),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("• $e", style: const TextStyle(fontSize: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
