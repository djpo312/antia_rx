enum WodFormat {
  amrap,
  emom,
  forTime,
  chipper,
  rounds,
  tabata,
  deathBy,
  ladder,
  interval,
  buyInCashOut,
  benchmark,
  complex,
}

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

      case WodFormat.tabata:
        return "TABATA";

      case WodFormat.deathBy:
        return "DEATH BY";

      case WodFormat.ladder:
        return "LADDER";

      case WodFormat.interval:
        return "INTERVALOS";

      case WodFormat.buyInCashOut:
        return "BUY-IN / CASH-OUT";

      case WodFormat.benchmark:
        return "WOD FAMOSO";

      case WodFormat.complex:
        return "COMPLEX";
    }
  }
}
