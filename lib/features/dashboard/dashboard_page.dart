import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/app_version.dart';
import '../../core/utils/spanish_date.dart';
import '../../providers/app_storage_provider.dart';
import '../crossfit/crossfit_page.dart';
import '../gym/gym_page.dart';
import '../hyrox/hyrox_page.dart';
import '../running/running_page.dart';
import '../workout/equipment_icons.dart';
import '../workout/wod_completion_toggle.dart';
import '../workout/workout_builder_page.dart';
import '../workout/workout_model.dart';
import '../workout/workout_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyWorkout = ref.watch(dailyWorkoutProvider);
    final userName = ref.watch(userNameProvider) ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "ANTIA RX",
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                "v$appVersion",
                style: const TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hola, $userName",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "TU INTELIGENCIA PARA ENTRENAR MÁS FUERTE",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppTheme.accent,
              ),
            ),

            const SizedBox(height: 20),

            _menuCard(
              context,
              Icons.fitness_center,
              "CrossFit",
              const CrossfitPage(),
            ),

            _menuCard(
              context,
              Icons.directions_run,
              "Running",
              const RunningPage(),
            ),

            _menuCard(
              context,
              Icons.local_fire_department,
              "Hyrox",
              const HyroxPage(),
            ),

            _menuCard(
              context,
              Icons.sports_gymnastics,
              "Gimnasio",
              const GymPage(),
            ),

            _menuCard(
              context,
              Icons.auto_awesome,
              "Generador de WOD",
              const WorkoutBuilderPage(),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: dailyWorkout.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => Text(error.toString()),
                  data: (workout) => _wodOfTheDay(context, workout),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Resumen semanal",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "🏋 Entrenamientos: ${ref.watch(weeklyCompletedWodsProvider)}",
                    ),
                    const Text("🔥 Calorías: 0"),
                    const Text("⏱ Tiempo: 0 min"),
                    const Text("🏆 PR nuevos: 0"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wodOfTheDay(BuildContext context, WorkoutModel workout) {
    final wodSection = workout.sections.firstWhere(
      (section) => section.name == "WOD",
      orElse: () => workout.sections.last,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "🔥 WOD del día",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              "${workout.totalMinutes} min",
              style: const TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          formatSpanishDate(DateTime.now()),
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),

        const SizedBox(height: 10),

        Text(
          wodSection.subtitle ?? wodSection.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.accent,
          ),
        ),

        const Divider(),

        ...wodSection.exercises.map(
          (exercise) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 15,
              backgroundColor: AppTheme.surface,
              child: Text(
                equipmentEmoji(exercise.equipment),
                style: const TextStyle(fontSize: 15),
              ),
            ),
            title: Text(exercise.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  [
                    if (exercise.reps != null) "${exercise.reps} reps",
                    if (exercise.duration != null) exercise.duration!,
                    if (exercise.distance != null) exercise.distance!,
                    if (exercise.weight != null) exercise.weight!,
                    if (exercise.equipment != null &&
                        exercise.equipment != "None" &&
                        exercise.equipment != "Run")
                      exercise.equipment!,
                  ].join(" • "),
                ),
                if (exercise.notes != null)
                  Text(
                    exercise.notes!,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        const WodCompletionToggle(),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CrossfitPage()),
            ),
            child: const Text("Ver entrenamiento completo"),
          ),
        ),
      ],
    );
  }

  Widget _menuCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.accent,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white38),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
