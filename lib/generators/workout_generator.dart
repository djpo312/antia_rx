import '../database/app_database.dart';
import '../models/training_session.dart';

class WorkoutGenerator {
  final AppDatabase database;

  WorkoutGenerator(this.database);

  Future<TrainingSession> generateTodayWorkout() async {
    final exercises = await database.getAllExercises();

    return TrainingSession(
      title: "CrossFit del día",

      warmup: ["500 m Run", "20 Air Squat", "15 Push-up"],

      mobility: ["World Greatest Stretch", "PVC Pass Through"],

      strength: ["Back Squat 5x5"],

      wod: ["21-15-9", "Thruster", "Pull-up"],

      accessory: ["3x15 GHD Sit-up"],

      cooldown: ["Foam Roll", "Stretch"],
    );
  }
}
