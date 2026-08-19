/// Carga Rx aproximada (lb) para los movimientos con peso externo más
/// comunes en CrossFit. Sirve como referencia general, no como
/// prescripción médica ni de un coach certificado.
const Map<String, double> _rxWeightsLb = {
  "Back Squat": 175,
  "Front Squat": 155,
  "Deadlift": 225,
  "Thruster": 95, // Rx clásico de Fran
  "Overhead Press": 115,
  "Kettlebell Swing": 53, // KB Rx clásica
  "Wall Ball": 20, // Wall Ball Rx clásico
  "Sandbag Carry": 90,
};

/// Sugerencia de peso para los 3 niveles estándar de CrossFit.
class WeightSuggestion {
  final double scaled;
  final double intermediate;
  final double rx;

  const WeightSuggestion({
    required this.scaled,
    required this.intermediate,
    required this.rx,
  });

  /// Devuelve la sugerencia de peso para [exerciseName], o null si el
  /// ejercicio no tiene una carga externa de referencia (ej. bodyweight,
  /// cardio, movilidad).
  static WeightSuggestion? forExercise(String exerciseName, {double variance = 0}) {
    final base = _rxWeightsLb[exerciseName];
    if (base == null) return null;

    final rx = base + variance;

    return WeightSuggestion(
      scaled: _roundToStep(rx * 0.55),
      intermediate: _roundToStep(rx * 0.75),
      rx: _roundToStep(rx),
    );
  }

  static double _roundToStep(double value, [double step = 5]) {
    final rounded = (value / step).round() * step;
    return rounded < step ? step : rounded;
  }

  static String _fmt(double value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);

  String get label =>
      "Scaled ${_fmt(scaled)}lb · Intermedio ${_fmt(intermediate)}lb · Rx ${_fmt(rx)}lb";
}
