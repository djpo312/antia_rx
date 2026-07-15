import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class CsvImporter {
  Future<List<List<dynamic>>> load(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);

    return const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
    ).convert(raw);
  }
}
