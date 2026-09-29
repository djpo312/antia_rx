import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_storage_provider.dart';

/// Botón para guardar (o quitar) el WOD de hoy de [category] entre los
/// favoritos. Solo guarda la fecha: el WOD se puede volver a generar tal
/// cual con la misma semilla, así que no hace falta guardar el contenido.
class WodFavoriteToggle extends ConsumerWidget {
  const WodFavoriteToggle({super.key, this.category = "crossfit"});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(isWodFavoritedTodayProvider(category));

    return OutlinedButton.icon(
      onPressed: () => toggleTodayWodFavorite(ref, category: category),
      style: saved
          ? OutlinedButton.styleFrom(foregroundColor: Colors.redAccent)
          : null,
      icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
      label: Text(saved ? "Guardado en favoritos" : "Guardar favorito"),
    );
  }
}
