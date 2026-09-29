// Web worker que le permite a drift correr la base de datos SQLite en un
// hilo aparte del hilo principal, usando IndexedDB/OPFS como almacenamiento
// persistente en el navegador. Se compila a drift_worker.js (ver README de
// este proyecto / comando usado al generarlo) y drift lo carga solo, no
// hace falta tocarlo a mano.
import 'package:drift/wasm.dart';

void main() {
  WasmDatabase.workerMainForOpen();
}
