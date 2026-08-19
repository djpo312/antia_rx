import 'dart:math';

import 'wod_format.dart';

class WodFormatGenerator {
  WodFormatGenerator({Random? random}) : random = random ?? Random();

  final Random random;

  WodFormat randomFormat() {
    return WodFormat.values[random.nextInt(WodFormat.values.length)];
  }

  String description(WodFormat format) {
    switch (format) {
      case WodFormat.amrap:
        return "AMRAP ${10 + random.nextInt(11)}'";

      case WodFormat.emom:
        return "EMOM ${10 + random.nextInt(11)}'";

      case WodFormat.forTime:
        return "For Time";

      case WodFormat.chipper:
        return "Chipper";

      case WodFormat.rounds:
        return "${3 + random.nextInt(3)} Rondas";
    }
  }
}
