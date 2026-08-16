enum WodFormat { amrap, emom, forTime, chipper, rounds }

extension WodFormatExtension on WodFormat {
  String get title {
    switch (this) {
      case WodFormat.amrap:
        return "AMRAP";

      case WodFormat.emom:
        return "EMOM";

      case WodFormat.forTime:
        return "FOR TIME";

      case WodFormat.chipper:
        return "CHIPPER";

      case WodFormat.rounds:
        return "ROUNDS";
    }
  }
}
