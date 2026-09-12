import 'dart:math';

import '../workout_model.dart';
import 'weight_table.dart';

/// WODs de referencia ("Girls" y "Hero WODs") de CrossFit: recetas fijas
/// y famosas, no generadas al azar desde el catálogo. Los pesos Rx están
/// tomados de la programación oficial (en libras, estándar masculino).
class BenchmarkWod {
  final String name;
  final String formatLabel;

  /// Si es null, la sección usa el minutaje del día como tope ("cap").
  /// Si tiene valor, el WOD tiene una duración fija por definición
  /// (ej. Cindy siempre es un AMRAP de 20').
  final int? fixedMinutes;

  final List<WorkoutExerciseModel> Function() exercises;

  const BenchmarkWod({
    required this.name,
    required this.formatLabel,
    this.fixedMinutes,
    required this.exercises,
  });
}

/// Murph: el WOD que CrossFit HQ designó oficialmente para el Memorial Day
/// (el último lunes de mayo, en honor a los caídos en combate). Se maneja
/// aparte del resto porque tiene una fecha real asociada.
final murphWod = BenchmarkWod(
  name: "Murph",
  formatLabel: "For Time",
  exercises: () => [
    const WorkoutExerciseModel(
      name: "Run",
      equipment: "Run",
      distance: "1 milla",
      notes: "Con chaleco de 20lb si vas Rx",
    ),
    const WorkoutExerciseModel(name: "Pull-up", equipment: "Pull-up Bar", reps: "100"),
    const WorkoutExerciseModel(name: "Push-up", equipment: "None", reps: "200"),
    const WorkoutExerciseModel(name: "Air Squat", equipment: "None", reps: "300"),
    const WorkoutExerciseModel(name: "Run", equipment: "Run", distance: "1 milla"),
  ],
);

/// Resto de WODs famosos ("Girls" clásicas + algunos "Hero WOD"), elegidos
/// al azar como una opción más del generador.
final List<BenchmarkWod> benchmarkWods = [
  BenchmarkWod(
    name: "Fran",
    formatLabel: "For Time",
    exercises: () => [
      WorkoutExerciseModel(
        name: "Thruster",
        equipment: "Barbell",
        reps: "21-15-9",
        weight: WeightSuggestion.fromRx(95).label,
      ),
      const WorkoutExerciseModel(
        name: "Pull-up",
        equipment: "Pull-up Bar",
        reps: "21-15-9",
      ),
    ],
  ),
  BenchmarkWod(
    name: "Helen",
    formatLabel: "3 Rondas · For Time",
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Run",
        equipment: "Run",
        distance: "400m",
      ),
      WorkoutExerciseModel(
        name: "Kettlebell Swing",
        equipment: "Kettlebell",
        reps: "21",
        weight: WeightSuggestion.fromRx(53).label,
      ),
      const WorkoutExerciseModel(
        name: "Pull-up",
        equipment: "Pull-up Bar",
        reps: "12",
      ),
    ],
  ),
  BenchmarkWod(
    name: "Cindy",
    formatLabel: "AMRAP",
    fixedMinutes: 20,
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Pull-up",
        equipment: "Pull-up Bar",
        reps: "5",
      ),
      const WorkoutExerciseModel(name: "Push-up", equipment: "None", reps: "10"),
      const WorkoutExerciseModel(name: "Air Squat", equipment: "None", reps: "15"),
    ],
  ),
  BenchmarkWod(
    name: "Grace",
    formatLabel: "For Time",
    exercises: () => [
      WorkoutExerciseModel(
        name: "Clean and Jerk",
        equipment: "Barbell",
        reps: "30",
        weight: WeightSuggestion.fromRx(135).label,
      ),
    ],
  ),
  BenchmarkWod(
    name: "Diane",
    formatLabel: "For Time",
    exercises: () => [
      WorkoutExerciseModel(
        name: "Deadlift",
        equipment: "Barbell",
        reps: "21-15-9",
        weight: WeightSuggestion.fromRx(225).label,
      ),
      const WorkoutExerciseModel(
        name: "Handstand Push-up",
        equipment: "None",
        reps: "21-15-9",
      ),
    ],
  ),
  BenchmarkWod(
    name: "Annie",
    formatLabel: "For Time",
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Double Under",
        equipment: "Rope",
        reps: "50-40-30-20-10",
      ),
      const WorkoutExerciseModel(
        name: "Sit-up",
        equipment: "None",
        reps: "50-40-30-20-10",
      ),
    ],
  ),
  BenchmarkWod(
    name: "Karen",
    formatLabel: "For Time",
    exercises: () => [
      WorkoutExerciseModel(
        name: "Wall Ball",
        equipment: "Wall Ball",
        reps: "150",
        weight: WeightSuggestion.fromRx(20).label,
      ),
    ],
  ),
  BenchmarkWod(
    name: "Isabel",
    formatLabel: "For Time",
    exercises: () => [
      WorkoutExerciseModel(
        name: "Squat Snatch",
        equipment: "Barbell",
        reps: "30",
        weight: WeightSuggestion.fromRx(135).label,
      ),
    ],
  ),
  BenchmarkWod(
    name: "Jackie",
    formatLabel: "For Time",
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Row",
        equipment: "Concept2 Rower",
        distance: "1000m",
      ),
      WorkoutExerciseModel(
        name: "Thruster",
        equipment: "Barbell",
        reps: "50",
        weight: WeightSuggestion.fromRx(45).label,
      ),
      const WorkoutExerciseModel(
        name: "Pull-up",
        equipment: "Pull-up Bar",
        reps: "30",
      ),
    ],
  ),
  BenchmarkWod(
    name: "Elizabeth",
    formatLabel: "For Time",
    exercises: () => [
      WorkoutExerciseModel(
        name: "Squat Clean",
        equipment: "Barbell",
        reps: "21-15-9",
        weight: WeightSuggestion.fromRx(135).label,
      ),
      const WorkoutExerciseModel(
        name: "Ring Dip",
        equipment: "Rings",
        reps: "21-15-9",
      ),
    ],
  ),
  BenchmarkWod(
    name: "Nancy",
    formatLabel: "5 Rondas · For Time",
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Run",
        equipment: "Run",
        distance: "400m",
      ),
      WorkoutExerciseModel(
        name: "Overhead Squat",
        equipment: "Barbell",
        reps: "15",
        weight: WeightSuggestion.fromRx(95).label,
      ),
    ],
  ),
  BenchmarkWod(
    name: "Angie",
    formatLabel: "For Time",
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Pull-up",
        equipment: "Pull-up Bar",
        reps: "100",
      ),
      const WorkoutExerciseModel(name: "Push-up", equipment: "None", reps: "100"),
      const WorkoutExerciseModel(name: "Sit-up", equipment: "None", reps: "100"),
      const WorkoutExerciseModel(name: "Air Squat", equipment: "None", reps: "100"),
    ],
  ),
  BenchmarkWod(
    name: "Barbara",
    formatLabel: "5 Rondas · For Time",
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Pull-up",
        equipment: "Pull-up Bar",
        reps: "20",
        notes: "Descansa 3' entre rondas",
      ),
      const WorkoutExerciseModel(name: "Push-up", equipment: "None", reps: "30"),
      const WorkoutExerciseModel(name: "Sit-up", equipment: "None", reps: "40"),
      const WorkoutExerciseModel(name: "Air Squat", equipment: "None", reps: "50"),
    ],
  ),
  BenchmarkWod(
    name: "Chelsea",
    formatLabel: "EMOM",
    fixedMinutes: 30,
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Pull-up",
        equipment: "Pull-up Bar",
        reps: "5",
        notes: "Cada minuto",
      ),
      const WorkoutExerciseModel(
        name: "Push-up",
        equipment: "None",
        reps: "10",
        notes: "Cada minuto",
      ),
      const WorkoutExerciseModel(
        name: "Air Squat",
        equipment: "None",
        reps: "15",
        notes: "Cada minuto",
      ),
    ],
  ),
  BenchmarkWod(
    name: "Eva",
    formatLabel: "5 Rondas · For Time",
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Run",
        equipment: "Run",
        distance: "800m",
      ),
      WorkoutExerciseModel(
        name: "Kettlebell Swing",
        equipment: "Kettlebell",
        reps: "30",
        weight: WeightSuggestion.fromRx(70).label,
      ),
      const WorkoutExerciseModel(
        name: "Pull-up",
        equipment: "Pull-up Bar",
        reps: "30",
      ),
    ],
  ),
  BenchmarkWod(
    name: "DT",
    formatLabel: "5 Rondas · For Time",
    exercises: () => [
      WorkoutExerciseModel(
        name: "Deadlift",
        equipment: "Barbell",
        reps: "12",
        weight: WeightSuggestion.fromRx(155).label,
      ),
      WorkoutExerciseModel(
        name: "Hang Power Clean",
        equipment: "Barbell",
        reps: "9",
        weight: WeightSuggestion.fromRx(155).label,
      ),
      WorkoutExerciseModel(
        name: "Push Jerk",
        equipment: "Barbell",
        reps: "6",
        weight: WeightSuggestion.fromRx(155).label,
      ),
    ],
  ),
  BenchmarkWod(
    name: "JT",
    formatLabel: "For Time",
    exercises: () => [
      const WorkoutExerciseModel(
        name: "Handstand Push-up",
        equipment: "None",
        reps: "21-15-9",
      ),
      const WorkoutExerciseModel(
        name: "Ring Dip",
        equipment: "Rings",
        reps: "21-15-9",
      ),
      const WorkoutExerciseModel(
        name: "Push-up",
        equipment: "None",
        reps: "21-15-9",
      ),
    ],
  ),
  BenchmarkWod(
    name: "Randy",
    formatLabel: "For Time",
    exercises: () => [
      WorkoutExerciseModel(
        name: "Power Snatch",
        equipment: "Barbell",
        reps: "75",
        weight: WeightSuggestion.fromRx(75).label,
      ),
    ],
  ),
];

WorkoutSectionModel buildBenchmarkSection(BenchmarkWod wod, int minutes) {
  final duration = wod.fixedMinutes ?? minutes;
  final subtitle = wod.fixedMinutes != null
      ? "${wod.name.toUpperCase()} · ${wod.formatLabel} $duration'"
      : "${wod.name.toUpperCase()} · ${wod.formatLabel} (cap $minutes')";

  return WorkoutSectionModel(
    name: "WOD",
    subtitle: subtitle,
    durationMinutes: duration,
    exercises: wod.exercises(),
  );
}

/// El último lunes de mayo (Memorial Day en EE. UU.), fecha oficial en la
/// que CrossFit HQ designa a Murph como el WOD del día.
bool isMemorialDay(DateTime date) {
  var monday = DateTime(date.year, 5, 31);
  while (monday.weekday != DateTime.monday) {
    monday = monday.subtract(const Duration(days: 1));
  }
  return date.year == monday.year &&
      date.month == monday.month &&
      date.day == monday.day;
}

class BenchmarkGenerator {
  BenchmarkGenerator({Random? random}) : random = random ?? Random();

  final Random random;

  WorkoutSectionModel generate(int minutes) {
    final wod = benchmarkWods[random.nextInt(benchmarkWods.length)];
    return buildBenchmarkSection(wod, minutes);
  }
}
