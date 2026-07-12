import '../models/exercise.dart';
import '../models/workout.dart';

final crossfitWorkout = Workout(
  id: 'wod001',
  title: 'WOD del Día',
  date: DateTime.now(),
  exercises: [
    Exercise(
      id: 'e1',
      name: 'Air Squat',
      category: 'CrossFit',
      description: '3 series de 20 repeticiones',
    ),
    Exercise(
      id: 'e2',
      name: 'Push-up',
      category: 'CrossFit',
      description: '3 series de 15 repeticiones',
    ),
    Exercise(
      id: 'e3',
      name: 'Burpees',
      category: 'CrossFit',
      description: '3 series de 10 repeticiones',
    ),
  ],
);
