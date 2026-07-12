import 'exercise.dart';

class Workout {
  final String id;
  final String title;
  final DateTime date;
  final List<Exercise> exercises;

  const Workout({
    required this.id,
    required this.title,
    required this.date,
    required this.exercises,
  });
}
