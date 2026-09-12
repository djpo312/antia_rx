import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia simple en un solo valor JSON: el nombre del usuario (para
/// personalizar la app) y los días en que marcó su WOD como hecho (para
/// llevar seguimiento). Usa shared_preferences en vez de un archivo propio
/// porque funciona igual en Android/iOS/desktop y en la versión web (PWA),
/// sin código específico por plataforma. No usa una tabla de Drift porque
/// es configuración liviana, no un catálogo de datos.
class AppStorageService {
  AppStorageService._(this._prefs, this._data);

  static const _storageKey = 'app_prefs_json';

  final SharedPreferences? _prefs;
  final Map<String, dynamic> _data;

  /// Instancia en memoria sin tocar disco, para widget tests.
  factory AppStorageService.empty() => AppStorageService._(null, {});

  static Future<AppStorageService> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    Map<String, dynamic> data = {};

    if (raw != null) {
      try {
        data = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        // Valor corrupto o vacío: arrancamos de cero sin tronar la app.
        data = {};
      }
    }

    return AppStorageService._(prefs, data);
  }

  Future<void> _save() async {
    await _prefs?.setString(_storageKey, jsonEncode(_data));
  }

  // --- Nombre del usuario ---

  String? get userName => _data['userName'] as String?;

  Future<void> setUserName(String name) async {
    _data['userName'] = name.trim();
    await _save();
  }

  // --- Seguimiento de WODs completados ---
  // [category] identifica la sección ("crossfit", "posparto", ...). El
  // valor por defecto ("crossfit") usa la misma clave que ya se guardaba
  // antes de que existiera más de una categoría, así el historial viejo
  // se sigue leyendo igual.

  String _completedWodsKey(String category) =>
      category == "crossfit" ? "completedWods" : "completedWods_$category";

  Map<String, String> _completedWods(String category) {
    final raw = _data[_completedWodsKey(category)] as Map<String, dynamic>?;
    if (raw == null) return {};
    return raw.map((key, value) => MapEntry(key, value as String));
  }

  bool isWodCompleted(DateTime date, {String category = "crossfit"}) =>
      _completedWods(category).containsKey(_dateKey(date));

  Future<void> markWodCompleted(
    DateTime date, {
    String category = "crossfit",
  }) async {
    final completed = Map<String, String>.from(_completedWods(category));
    completed[_dateKey(date)] = DateTime.now().toIso8601String();
    _data[_completedWodsKey(category)] = completed;
    await _save();
  }

  Future<void> unmarkWodCompleted(
    DateTime date, {
    String category = "crossfit",
  }) async {
    final completed = Map<String, String>.from(_completedWods(category));
    completed.remove(_dateKey(date));
    _data[_completedWodsKey(category)] = completed;
    await _save();
  }

  /// Cuántos WODs marcó como hechos en los últimos [days] días (incluye hoy).
  int completedWodsInLast(int days, {String category = "crossfit"}) {
    final now = DateTime.now();

    return _completedWods(category).keys.where((key) {
      final date = DateTime.tryParse(key);
      if (date == null) return false;
      final diff = now.difference(date).inDays;
      return diff >= 0 && diff < days;
    }).length;
  }

  // --- WODs guardados como favoritos ---
  // Guarda solo la fecha (+ categoría): el contenido se puede regenerar
  // de forma reproducible con la misma semilla (ver dateSeed en
  // workout_provider.dart), así que no hace falta duplicar el WOD entero.

  String _favoriteWodsKey(String category) => "favoriteWods_$category";

  Set<String> _favoriteWodDateKeys(String category) {
    final raw = _data[_favoriteWodsKey(category)] as List<dynamic>?;
    if (raw == null) return {};
    return raw.map((e) => e.toString()).toSet();
  }

  bool isWodFavorited(DateTime date, {String category = "crossfit"}) =>
      _favoriteWodDateKeys(category).contains(_dateKey(date));

  Future<void> toggleWodFavorite(
    DateTime date, {
    String category = "crossfit",
  }) async {
    final favorites = _favoriteWodDateKeys(category);
    final key = _dateKey(date);

    if (favorites.contains(key)) {
      favorites.remove(key);
    } else {
      favorites.add(key);
    }

    _data[_favoriteWodsKey(category)] = favorites.toList();
    await _save();
  }

  /// Fechas favoritas de [category], más reciente primero.
  List<DateTime> favoriteWodDates({String category = "crossfit"}) {
    final dates = _favoriteWodDateKeys(
      category,
    ).map((key) => DateTime.tryParse(key)).whereType<DateTime>().toList();

    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }

  String _dateKey(DateTime date) =>
      "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";

  // --- Versión del catálogo de ejercicios ya sembrada en este teléfono ---
  // Se compara contra `catalogVersion` (lib/core/app_version.dart) al
  // arrancar para decidir si hay que reimportar los CSV de ejercicios.

  int get catalogVersion => (_data['catalogVersion'] as num?)?.toInt() ?? 0;

  Future<void> setCatalogVersion(int version) async {
    _data['catalogVersion'] = version;
    await _save();
  }
}
