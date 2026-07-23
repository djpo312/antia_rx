class ExerciseListItem {
  final int id;
  final String code;
  final String name;
  final String description;

  final String category;
  final String equipment;
  final String difficulty;
  final String movement;

  const ExerciseListItem({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.category,
    required this.equipment,
    required this.difficulty,
    required this.movement,
  });
}
