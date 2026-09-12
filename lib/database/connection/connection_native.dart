import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Conexión para Android/iOS/desktop: un archivo SQLite real en el
/// almacenamiento de la app, vía FFI nativo.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'vida_asistente.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
