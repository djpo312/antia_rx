import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/services/app_storage_service.dart';
import 'database/app_database.dart';
import 'database/seed/database_seed.dart';
import 'providers/app_storage_provider.dart';
import 'repositories/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  await DatabaseSeed(database).initialize();

  final storage = await AppStorageService.load();

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
