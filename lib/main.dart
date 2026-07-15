import 'package:flutter/material.dart';

import 'app/app.dart';
import 'database/app_database.dart';
import 'database/seed/database_seed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  await DatabaseSeed(database).initialize();

  runApp(const VidaAsistenteApp());
}
