/// Punto de entrada único para abrir la base de datos: elige la
/// implementación nativa (Android/iOS/desktop) o la de WebAssembly (PWA)
/// según la plataforma, sin que el resto del código tenga que saberlo.
export 'connection_web.dart' if (dart.library.io) 'connection_native.dart';
