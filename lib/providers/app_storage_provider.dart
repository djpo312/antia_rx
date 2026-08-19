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

/// Se incrementa cada vez que se marca/desmarca el WOD del día como hecho,
/// para que los widgets que dependen de ese estado se refresquen.
final wodCompletionTickProvider = StateProvider<int>((ref) => 0);

/// Si el WOD de hoy ya está marcado como hecho.
final isWodCompletedTodayProvider = Provider<bool>((ref) {
  ref.watch(wodCompletionTickProvider);
  return ref.watch(appStorageProvider).isWodCompleted(DateTime.now());
});

/// Cuántos WODs se completaron en los últimos 7 días.
final weeklyCompletedWodsProvider = Provider<int>((ref) {
  ref.watch(wodCompletionTickProvider);
  return ref.watch(appStorageProvider).completedWodsInLast(7);
});

/// Marca (o desmarca) el WOD de hoy como hecho y notifica a los widgets
/// que dependan de [isWodCompletedTodayProvider] / [weeklyCompletedWodsProvider].
Future<void> toggleTodayWodCompleted(WidgetRef ref) async {
  final storage = ref.read(appStorageProvider);
  final today = DateTime.now();

  if (storage.isWodCompleted(today)) {
    await storage.unmarkWodCompleted(today);
  } else {
    await storage.markWodCompleted(today);
  }

  ref.read(wodCompletionTickProvider.notifier).state++;
}
