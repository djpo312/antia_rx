import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workout_provider.dart';

class WorkoutBuilderPage extends ConsumerWidget {
  const WorkoutBuilderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generator = ref.watch(workoutProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Generador de WOD")),
      body: FutureBuilder(
        future: generator.generate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final workout = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                workout.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Chip(label: Text(workout.type)),

              const SizedBox(height: 20),

              ...workout.sections.map(
                (section) => Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (section.subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              section.subtitle!,
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),

                        const Divider(),

                        ...section.exercises.map(
                          (exercise) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  size: 18,
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          exercise.weight != null ||
                                          exercise.duration != null ||
                                          exercise.distance != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2,
                                          ),
                                          child: Text(
                                            [
                                              if (exercise.sets != null)
                                                "${exercise.sets} series",
                                              if (exercise.reps != null)
                                                "${exercise.reps} reps",
                                              if (exercise.weight != null)
                                                exercise.weight!,
                                              if (exercise.duration != null)
                                                exercise.duration!,
                                              if (exercise.distance != null)
                                                exercise.distance!,
                                            ].join(" • "),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),

                                      if (exercise.notes != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2,
                                          ),
                                          child: Text(
                                            exercise.notes!,
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
