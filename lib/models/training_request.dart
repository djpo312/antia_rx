import 'sport.dart';
import 'training_goal.dart';
import 'training_level.dart';

class TrainingRequest {
  final Sport sport;
  final TrainingGoal goal;
  final TrainingLevel level;
  final int durationMinutes;

  const TrainingRequest({
    required this.sport,
    required this.goal,
    required this.level,
    required this.durationMinutes,
  });
}
