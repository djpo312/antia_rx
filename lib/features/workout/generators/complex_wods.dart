import 'dart:math';

import '../workout_model.dart';
import 'weight_table.dart';

/// Un "complex" es una secuencia de movimientos con barra que se hacen
/// seguidos, sin soltar la barra entre uno y otro, dentro de una misma
/// ronda (sí se puede soltar y descansar entre rondas). Es distinto a un
/// WOD normal: no se trata de ir rápido, sino de mantener la barra en las
/// manos con buena técnica movimiento tras movimiento.
class BarbellComplex {
  final String name;
  final List<String> movements;
  final int rounds;
  final int repsPerMovement;
  final double rxWeight;

  const BarbellComplex({
    required this.name,
    required this.movements,
    required this.rounds,
    required this.repsPerMovement,
    required this.rxWeight,
  });
}

const List<BarbellComplex> barbellComplexes = [
  BarbellComplex(
    name: "Bear Complex",
    movements: [
      "Power Clean",
      "Front Squat",
      "Push Press",
      "Back Squat",
      "Push Press",
    ],
    rounds: 5,
    repsPerMovement: 1,
    rxWeight: 115,
  ),
  BarbellComplex(
    name: "Complex de Cargada",
    movements: ["Power Clean", "Front Squat", "Push Jerk"],
    rounds: 5,
    repsPerMovement: 3,
    rxWeight: 135,
  ),
  BarbellComplex(
    name: "Complex de Arranque",
    movements: ["Power Snatch", "Overhead Squat"],
    rounds: 5,
    repsPerMovement: 3,
    rxWeight: 95,
  ),
  BarbellComplex(
    name: "Complex de Peso Muerto",
    movements: ["Deadlift", "Hang Power Clean", "Front Squat", "Push Press"],
    rounds: 5,
    repsPerMovement: 3,
    rxWeight: 135,
  ),
  BarbellComplex(
    name: "Complex Thruster",
    movements: ["Squat Clean", "Thruster"],
    rounds: 5,
    repsPerMovement: 3,
    rxWeight: 115,
  ),
  BarbellComplex(
    name: "Complex de Sentadillas",
    movements: ["Front Squat", "Overhead Squat"],
    rounds: 5,
    repsPerMovement: 3,
    rxWeight: 95,
  ),
];

class ComplexGenerator {
  ComplexGenerator({Random? random}) : random = random ?? Random();

  final Random random;

  WorkoutSectionModel generate(int minutes) {
    final complex = barbellComplexes[random.nextInt(barbellComplexes.length)];
    final weights = WeightSuggestion.fromRx(complex.rxWeight);

    final exercises = complex.movements.asMap().entries.map((entry) {
      final index = entry.key;
      final movement = entry.value;

      return WorkoutExerciseModel(
        name: movement,
        equipment: "Barbell",
        reps: "${complex.repsPerMovement}",
        weight: weights.label,
        notes: index == 0
            ? "No sueltes la barra hasta terminar la ronda"
            : null,
      );
    }).toList();

    return WorkoutSectionModel(
      name: "WOD",
      subtitle:
          "${complex.name.toUpperCase()} · ${complex.rounds} rondas (cap $minutes')",
      durationMinutes: minutes,
      exercises: exercises,
    );
  }
}
