import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/app_version.dart';
import 'core/services/app_storage_service.dart';
import 'database/app_database.dart';
import 'database/seed/database_seed.dart';
import 'providers/app_storage_provider.dart';
import 'repositories/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final storage = await AppStorageService.load();

  // Si el catálogo de ejercicios cambió desde la última vez que se abrió
  // la app en este teléfono, se reimporta solo (sin desinstalar).
  final needsCatalogReseed = storage.catalogVersion != catalogVersion;

  await DatabaseSeed(
    database,
  ).initialize(forceReseedExercises: needsCatalogReseed);

  if (needsCatalogReseed) {
    await storage.setCatalogVersion(catalogVersion);
  }

  runApp(
    ProviderScope(
      // Reutiliza las mismas instancias ya cargadas en lugar de crear otras.
      overrides: [
        databaseProvider.overrideWithValue(database),
        appStorageProvider.overrideWithValue(storage),
      ],
      child: const VidaAsistenteApp(),
    ),
  );
}
