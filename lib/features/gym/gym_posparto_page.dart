import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/workout_timer.dart';
import '../../core/utils/spanish_date.dart';
import '../workout/wod_completion_toggle.dart';
import '../workout/wod_favorite_toggle.dart';
import '../workout/workout_provider.dart';
import '../workout/workout_sections_view.dart';

/// Sesión de Gym Posparto del día: igual de estructura que CrossFit
/// (fecha, secciones, marcar hecho, cronómetro, favorito) pero con un
/// generador propio, de baja intensidad, pensado para 0-3 meses posparto.
class GymPospartoPage extends ConsumerWidget {
  const GymPospartoPage({super.key});

  static const _category = "posparto";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyWorkout = ref.watch(dailyPostpartumWorkoutProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Gym Posparto")),
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

            const SizedBox(height: 4),

            const Text(
              "Baja intensidad · sin impacto · 0-3 meses posparto",
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
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
