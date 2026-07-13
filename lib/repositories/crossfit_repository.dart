import '../features/crossfit/workouts.dart';
import '../models/workout.dart';

class CrossfitRepository {
  List<Workout> getAll() {
    return sampleWorkouts;
  }

  Workout getTodayWorkout() {
    return sampleWorkouts.first;
  }
}
