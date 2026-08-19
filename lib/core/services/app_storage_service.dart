import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persistencia simple en un archivo JSON local: el nombre del usuario
/// (para personalizar la app) y los días en que marcó su WOD como hecho
/// (para llevar seguimiento). No usa una tabla de Drift porque es
/// configuración liviana, no un catálogo de datos.
class AppStorageService {
  AppStorageService._(this._file, this._data);

  final File _file;
  final Map<String, dynamic> _data;

  /// Instancia en memoria sin tocar disco, para widget tests.
  factory AppStorageService.empty() =>
      AppStorageService._(File('_unused_in_tests.json'), {});

  static Future<AppStorageService> load() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app_prefs.json'));

    Map<String, dynamic> data = {};

    if (await file.exists()) {
      try {
        final raw = await file.readAsString();
        data = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        // Archivo corrupto o vacío: arrancamos de cero sin tronar la app.
        data = {};
      }
    }

    return AppStorageService._(file, data);
  }

  Future<void> _save() => _file.writeAsString(jsonEncode(_data));

  // --- Nombre del usuario ---

  String? get userName => _data['userName'] as String?;

  Future<void> setUserName(String name) async {
    _data['userName'] = name.trim();
    await _save();
  }

  // --- Seguimiento de WODs completados ---

  Map<String, String> get _completedWods {
    final raw = _data['completedWods'] as Map<String, dynamic>?;
    if (raw == null) return {};
    return raw.map((key, value) => MapEntry(key, value as String));
  }

  bool isWodCompleted(DateTime date) =>
      _completedWods.containsKey(_dateKey(date));

  Future<void> markWodCompleted(DateTime date) async {
    final completed = Map<String, String>.from(_completedWods);
    completed[_dateKey(date)] = DateTime.now().toIso8601String();
    _data['completedWods'] = completed;
    await _save();
  }

  Future<void> unmarkWodCompleted(DateTime date) async {
    final completed = Map<String, String>.from(_completedWods);
    completed.remove(_dateKey(date));
    _data['completedWods'] = completed;
    await _save();
  }

  /// Cuántos WODs marcó como hechos en los últimos [days] días (incluye hoy).
  int completedWodsInLast(int days) {
    final now = DateTime.now();

    return _completedWods.keys.where((key) {
      final date = DateTime.tryParse(key);
      if (date == null) return false;
      final diff = now.difference(date).inDays;
      return diff >= 0 && diff < days;
    }).length;
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
