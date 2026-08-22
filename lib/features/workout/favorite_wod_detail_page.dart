import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/spanish_date.dart';
import '../../providers/exercise_repository_provider.dart';
import 'generators/postpartum_generator.dart';
import 'workout_generator.dart';
import 'workout_model.dart';
import 'workout_provider.dart';
import 'workout_sections_view.dart';

/// Vuelve a generar (de forma reproducible, con la misma semilla de esa
/// fecha) el WOD guardado como favorito para poder verlo completo.
class FavoriteWodDetailPage extends ConsumerWidget {
  const FavoriteWodDetailPage({
    super.key,
    required this.date,
    required this.category,
  });

  final DateTime date;

  /// "crossfit" o "posparto".
  final String category;

  Future<WorkoutModel> _regenerate(WidgetRef ref) {
    final repository = ref.read(exerciseRepositoryProvider);
    final seed = dateSeed(date);

    if (category == "posparto") {
      return PostpartumGenerator(repository, seed: seed).generate();
    }

    return WorkoutGenerator(repository, seed: seed).generate();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(formatSpanishDate(date))),
      body: FutureBuilder<WorkoutModel>(
        future: _regenerate(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [WorkoutSectionsView(workout: snapshot.data!)],
          );
        },
      ),
    );
  }
}
