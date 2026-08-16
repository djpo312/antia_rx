class WorkoutModel {
  final String title;
  final String type;
  final List<WorkoutSectionModel> sections;

  const WorkoutModel({
    required this.title,
    required this.type,
    required this.sections,
  });
}

class WorkoutSectionModel {
  /// Nombre de la sección
  /// Ejemplo:
  /// Warm Up
  /// Strength
  /// Skill
  /// WOD
  /// Cool Downr
  final String name;

  /// Subtítulo opcional
  /// Ejemplo:
  /// AMRAP 15'
  /// EMOM 12'
  /// FOR TIME
  /// 5x5 @80%
  /// 3 rondas
  final String? subtitle;

  final List<WorkoutExerciseModel> exercises;

  const WorkoutSectionModel({
    required this.name,
    this.subtitle,
    required this.exercises,
  });
}

class WorkoutExerciseModel {
  final String name;

  /// Para fuerza
  final String? sets;
  final String? reps;
  final String? weight;

  /// Para trabajos por tiempo
  final String? duration;

  /// Para carrera, remo, ski, etc.
  final String? distance;

  /// Comentarios adicionales
  final String? notes;

  const WorkoutExerciseModel({
    required this.name,
    this.sets,
    this.reps,
    this.weight,
    this.duration,
    this.distance,
    this.notes,
  });
}
