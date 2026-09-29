import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workout_provider.dart';
import 'workout_sections_view.dart';

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
            children: [WorkoutSectionsView(workout: workout)],
          );
        },
      ),
    );
  }
}
