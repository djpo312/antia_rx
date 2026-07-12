import '../models/exercise.dart';
import '../models/workout.dart';

final List<Workout> sampleWorkouts = [
  Workout(
    id: '1',
    title: 'WOD del Día',
    date: DateTime.now(),
    exercises: const [
      Exercise(
        name: 'Air Squat',
        sets: 3,
        reps: 20,
        weight: 0,
        duration: Duration(),
      ),
      Exercise(
        name: 'Push-up',
        sets: 3,
        reps: 15,
        weight: 0,
        duration: Duration(),
      ),
      Exercise(
        name: 'Burpees',
        sets: 3,
        reps: 10,
        weight: 0,
        duration: Duration(),
      ),
    ],
  ),
];
