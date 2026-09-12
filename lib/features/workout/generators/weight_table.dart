/// Carga Rx aproximada (lb) para los movimientos con peso externo más
/// comunes en CrossFit. Sirve como referencia general, no como
/// prescripción médica ni de un coach certificado.
const Map<String, double> _rxWeightsLb = {
  // Básicos con barra
  "Back Squat": 175,
  "Front Squat": 155,
  "Deadlift": 225,
  "Thruster": 95, // Rx clásico de Fran
  "Overhead Press": 115,

  // Halterofilia y variantes con barra
  "Sumo Deadlift High Pull": 75,
  "Power Clean": 135,
  "Squat Clean": 155,
  "Clean and Jerk": 135, // Rx clásico de Grace
  "Power Snatch": 95,
  "Squat Snatch": 135, // Rx clásico de Isabel
  "Push Press": 115,
  "Push Jerk": 135,
  "Split Jerk": 135,
  "Overhead Squat": 95, // Rx clásico de Nancy
  "Sumo Deadlift": 225,
  "Romanian Deadlift": 185,
  "Good Morning": 95,
  "Hip Thrust": 185,
  "Bench Press": 135,
  "Hang Power Clean": 155, // Rx clásico de DT

  // Mancuerna
  "Dumbbell Snatch": 50,
  "Dumbbell Clean": 50,
  "Dumbbell Thruster": 50,
  "Devil Press": 50,
  "Renegade Row": 50,
  "Man Makers": 50,
  "Farmers Carry": 50,

  // Kettlebell
  "Kettlebell Swing": 53, // KB Rx clásica
  "Turkish Get-up": 53,
  "Goblet Squat": 53,
  "Kettlebell Clean": 53,

  // Otros implementos con carga
  "Wall Ball": 20, // Wall Ball Rx clásico
  "Sandbag Carry": 90,
  "Medicine Ball Clean": 20,
  "Medicine Ball Slam": 20,
  "Sled Push": 135,
  "Sled Pull": 135,

  // Gimnasio (fuerza general y accesorios)
  "Barbell Row": 115,
  "Goblet Squat Gimnasio": 50,
  "Curl de Bíceps": 25,
  "Extensión de Tríceps": 20,
  "Elevación Lateral": 12,
  "Vuelo Posterior": 12,
  "Curl Martillo": 25,
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
  static WeightSuggestion? forExercise(
    String exerciseName, {
    double variance = 0,
  }) {
    final base = _rxWeightsLb[exerciseName];
    if (base == null) return null;

    return fromRx(base + variance);
  }

  /// Calcula los 3 niveles a partir de una carga Rx conocida directamente
  /// (ej. el Rx oficial de un WOD famoso como Fran o Grace), sin pasar
  /// por la tabla indexada por nombre de ejercicio.
  static WeightSuggestion fromRx(double rx) {
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
