import 'workout.dart';

class Session {
  final String id;
  final Workout workout;
  final DateTime date;
  final int duration;
  final int calories;

  const Session({
    required this.id,
    required this.workout,
    required this.date,
    required this.duration,
    required this.calories,
  });
}
