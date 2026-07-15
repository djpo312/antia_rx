import '../database/app_database.dart';
import '../repositories/exercise_repository.dart';

class ExerciseSelector {
  final ExerciseRepository repository;

  ExerciseSelector(this.repository);

  Future<List<Exercise>> randomExercises(int amount) async {
    final exercises = await repository.getAll();

    exercises.shuffle();

    return exercises.take(amount).toList();
  }
}
