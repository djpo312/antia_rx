import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'equipment_icons.dart';
import 'workout_model.dart';

/// Pinta el título, los chips (tipo + duración total) y las tarjetas de
/// cada sección de un [WorkoutModel]. Se reutiliza en el Generador de WOD
/// y en la pantalla de CrossFit, para que ambas se vean igual.
class WorkoutSectionsView extends StatelessWidget {
  const WorkoutSectionsView({super.key, required this.workout});

  final WorkoutModel workout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workout.title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Chip(label: Text(workout.type)),
            const SizedBox(width: 8),
            Chip(
              avatar: const Icon(Icons.timer_outlined, size: 18),
              label: Text("${workout.totalMinutes} min"),
            ),
          ],
        ),

        const SizedBox(height: 20),

        ...workout.sections.map(_buildSection),
      ],
    );
  }

  Widget _buildSection(WorkoutSectionModel section) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  section.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (section.durationMinutes != null)
                  Text(
                    "${section.durationMinutes} min",
                    style: const TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),

            if (section.subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  section.subtitle!,
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

            const Divider(),

            ...section.exercises.map(_buildExercise),
          ],
        ),
      ),
    );
  }

  Widget _buildExercise(WorkoutExerciseModel exercise) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: AppTheme.surface,
            child: Text(
              equipmentEmoji(exercise.equipment),
              style: const TextStyle(fontSize: 15),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                if (exercise.sets != null ||
                    exercise.reps != null ||
                    exercise.duration != null ||
                    exercise.distance != null ||
                    (exercise.equipment != null && exercise.equipment != "None"))
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      [
                        if (exercise.sets != null) "${exercise.sets} series",
                        if (exercise.reps != null) "${exercise.reps} reps",
                        if (exercise.duration != null) exercise.duration!,
                        if (exercise.distance != null) exercise.distance!,
                        if (exercise.equipment != null &&
                            exercise.equipment != "None" &&
                            exercise.equipment != "Run")
                          exercise.equipment!,
                      ].join(" • "),
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ),

                if (exercise.weight != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      exercise.weight!,
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),

                if (exercise.notes != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      exercise.notes!,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
