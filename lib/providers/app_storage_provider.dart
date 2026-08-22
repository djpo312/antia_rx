import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/app_storage_service.dart';

/// Se sobreescribe en main.dart con la instancia ya cargada desde disco
/// antes de correr la app (mismo patrón que databaseProvider).
final appStorageProvider = Provider<AppStorageService>((ref) {
  throw UnimplementedError(
    'appStorageProvider debe sobreescribirse en main() con la instancia cargada',
  );
});

/// Nombre del usuario. Arranca con lo que ya había guardado en disco; se
/// actualiza al terminar el onboarding o al editarlo desde Perfil.
final userNameProvider = StateProvider<String?>((ref) {
  return ref.watch(appStorageProvider).userName;
});

// --- Completado del WOD del día, por categoría ("crossfit", "posparto") ---

/// Se incrementa cada vez que se marca/desmarca un WOD como hecho, para
/// que los widgets que dependen de ese estado se refresquen.
final wodCompletionTickProvider = StateProvider<int>((ref) => 0);

/// Si el WOD de hoy de [category] ya está marcado como hecho.
final isWodCompletedTodayProvider = Provider.family<bool, String>((
  ref,
  category,
) {
  ref.watch(wodCompletionTickProvider);
  return ref
      .watch(appStorageProvider)
      .isWodCompleted(DateTime.now(), category: category);
});

/// Cuántos WODs de [category] se completaron en los últimos 7 días.
final weeklyCompletedWodsProvider = Provider.family<int, String>((
  ref,
  category,
) {
  ref.watch(wodCompletionTickProvider);
  return ref.watch(appStorageProvider).completedWodsInLast(7, category: category);
});

/// Marca (o desmarca) el WOD de hoy de [category] como hecho y notifica a
/// los widgets que dependan de [isWodCompletedTodayProvider] /
/// [weeklyCompletedWodsProvider].
Future<void> toggleTodayWodCompleted(
  WidgetRef ref, {
  String category = "crossfit",
}) async {
  final storage = ref.read(appStorageProvider);
  final today = DateTime.now();

  if (storage.isWodCompleted(today, category: category)) {
    await storage.unmarkWodCompleted(today, category: category);
  } else {
    await storage.markWodCompleted(today, category: category);
  }

  ref.read(wodCompletionTickProvider.notifier).state++;
}

// --- WODs favoritos, por categoría ---

/// Se incrementa cada vez que se marca/desmarca un WOD como favorito.
final wodFavoriteTickProvider = StateProvider<int>((ref) => 0);

/// Si el WOD de hoy de [category] está guardado como favorito.
final isWodFavoritedTodayProvider = Provider.family<bool, String>((
  ref,
  category,
) {
  ref.watch(wodFavoriteTickProvider);
  return ref
      .watch(appStorageProvider)
      .isWodFavorited(DateTime.now(), category: category);
});

/// Fechas favoritas guardadas para [category], más reciente primero.
final favoriteWodDatesProvider = Provider.family<List<DateTime>, String>((
  ref,
  category,
) {
  ref.watch(wodFavoriteTickProvider);
  return ref.watch(appStorageProvider).favoriteWodDates(category: category);
});

/// Marca (o desmarca) el WOD de hoy de [category] como favorito.
Future<void> toggleTodayWodFavorite(
  WidgetRef ref, {
  String category = "crossfit",
}) async {
  await ref
      .read(appStorageProvider)
      .toggleWodFavorite(DateTime.now(), category: category);

  ref.read(wodFavoriteTickProvider.notifier).state++;
}
