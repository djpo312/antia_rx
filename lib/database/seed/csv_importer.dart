import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class CsvImporter {
  Future<List<List<dynamic>>> load(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);

    print("===== RAW =====");
    print(raw);

    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(raw);

    print("===== PARSED =====");
    print(rows);

    return rows;
  }
}
