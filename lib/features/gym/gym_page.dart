import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/workout_timer.dart';
import '../../core/utils/spanish_date.dart';
import '../workout/wod_completion_toggle.dart';
import '../workout/wod_favorite_toggle.dart';
import '../workout/workout_provider.dart';
import '../workout/workout_sections_view.dart';

/// Sesión de Gimnasio del día: misma estructura que CrossFit/Gym Posparto
/// (fecha, secciones, marcar hecho, cronómetro, favorito) con un
/// generador propio de fuerza/musculación clásica, sin metcon.
class GymPage extends ConsumerWidget {
  const GymPage({super.key});

  static const _category = "gym";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyWorkout = ref.watch(dailyGymWorkoutProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Gimnasio")),
      body: dailyWorkout.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (workout) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              formatSpanishDate(DateTime.now()),
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 8),

            WorkoutSectionsView(workout: workout),

            const SizedBox(height: 15),

            const WodCompletionToggle(category: _category),

            const SizedBox(height: 15),

            const WorkoutTimer(),

            const SizedBox(height: 15),

            const WodFavoriteToggle(category: _category),
          ],
        ),
      ),
    );
  }
}
