/// Versión visible de ANTIA RX.
///
/// Convención: cada vez que se hace un cambio en la app se sube el número
/// después del punto (1.0 -> 1.1 -> 1.2 ...). Debe mantenerse en sync con
/// el campo `version:` de `pubspec.yaml` (ej. "1.3" aquí <-> "1.3.0+4" ahí).
const String appVersion = "1.3";

/// Versión del catálogo de ejercicios (assets/catalog/exercises.csv y
/// compañía). El catálogo solo se siembra una vez en la base de datos
/// local del teléfono, así que instalar una APK nueva encima de una
/// vieja NO trae ejercicios nuevos por sí solo. Súbela cada vez que
/// cambie el contenido de esos CSV: al arrancar, si el número guardado
/// en el teléfono no coincide con este, se reimporta el catálogo
/// automáticamente (sin necesidad de desinstalar la app).
const int catalogVersion = 1;
