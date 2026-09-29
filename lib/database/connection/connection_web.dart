import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Conexión para la versión web (PWA): SQLite compilado a WebAssembly.
///
/// Se fuerza IndexedDB simple (`unsafeIndexedDb`, sin worker compartido ni
/// OPFS) en vez de dejar que drift elija automáticamente: esa elección
/// automática prefiere OPFS + SharedWorker, que es la combinación menos
/// confiable entre navegadores (en particular en Safari de iPhone, que es
/// el destino real de esta PWA). "unsafe" acá solo significa que no hay
/// protección ante escrituras simultáneas desde varias pestañas a la vez,
/// algo que no aplica: esta app la usa una sola persona en una pestaña.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    const databaseName = 'vida_asistente';

    final probed = await WasmDatabase.probe(
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
      databaseName: databaseName,
    );

    final available = probed.availableStorages;
    final implementation =
        available.contains(WasmStorageImplementation.unsafeIndexedDb)
        ? WasmStorageImplementation.unsafeIndexedDb
        : (available.isNotEmpty
              ? available.first
              : WasmStorageImplementation.inMemory);

    return probed.open(implementation, databaseName);
  });
}
