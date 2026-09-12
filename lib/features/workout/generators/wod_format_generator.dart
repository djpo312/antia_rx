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

      case WodFormat.tabata:
        return "Tabata (8 rondas 20\"/10\")";

      case WodFormat.deathBy:
        return "Death By";

      case WodFormat.ladder:
        return "Ladder";

      case WodFormat.interval:
        return "Intervalos";

      case WodFormat.buyInCashOut:
        return "Buy-in / Cash-out";

      case WodFormat.benchmark:
        return "WOD famoso";

      case WodFormat.complex:
        return "Complex (barra sin soltar)";
    }
  }
}
