import '../database/app_database.dart';
import 'training_phase.dart';

class TrainingBlock {
  final TrainingPhase phase;
  final List<Exercise> exercises;

  const TrainingBlock({required this.phase, required this.exercises});
}

class TrainingSession {
  final DateTime date;
  final List<TrainingBlock> blocks;

  const TrainingSession({required this.date, required this.blocks});
}
