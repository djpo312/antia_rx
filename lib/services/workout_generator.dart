import '../database/app_database.dart';
import '../repositories/exercise_repository.dart';

class WorkoutGenerator {
  final ExerciseRepository repository;

  WorkoutGenerator(this.repository);

  Future<List<Exercise>> generateWarmup() async {
    final exercises = await repository.getAll();

    if (exercises.length <= 3) {
      return exercises;
    }

    exercises.shuffle();

    return exercises.take(3).toList();
  }
}
