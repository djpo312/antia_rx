import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'database/app_database.dart';
import 'database/seed/database_seed.dart';
import 'repositories/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  await DatabaseSeed(database).initialize();

  runApp(
    ProviderScope(
      // Reutiliza la misma instancia ya sembrada en lugar de abrir otra.
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const VidaAsistenteApp(),
    ),
  );
}
