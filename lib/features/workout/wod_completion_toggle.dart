import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_storage_provider.dart';

/// Botón para marcar (o desmarcar) el WOD de hoy de [category] como hecho.
/// El estado queda guardado en disco para llevar seguimiento día a día.
class WodCompletionToggle extends ConsumerWidget {
  const WodCompletionToggle({super.key, this.category = "crossfit"});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = ref.watch(isWodCompletedTodayProvider(category));

    if (done) {
      return OutlinedButton.icon(
        onPressed: () => toggleTodayWodCompleted(ref, category: category),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
        icon: const Icon(Icons.check_circle, color: Colors.green),
        label: const Text("¡Hecho hoy! Toca para deshacer"),
      );
    }

    return FilledButton.icon(
      onPressed: () => toggleTodayWodCompleted(ref, category: category),
      icon: const Icon(Icons.check),
      label: const Text("Marcar como hecho"),
    );
  }
}
