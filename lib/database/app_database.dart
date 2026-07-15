import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class Equipment extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class DifficultyLevels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class MovementPatterns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text().unique()();

  TextColumn get name => text()();

  TextColumn get description => text()();

  IntColumn get categoryId => integer()();

  IntColumn get equipmentId => integer()();

  IntColumn get difficultyId => integer()();

  IntColumn get movementPatternId => integer()();

  TextColumn get instructions => text()();

  TextColumn get videoUrl => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();

  BoolColumn get isStrength => boolean().withDefault(const Constant(false))();

  BoolColumn get isMetcon => boolean().withDefault(const Constant(false))();

  BoolColumn get isAccessory => boolean().withDefault(const Constant(false))();

  BoolColumn get isCooldown => boolean().withDefault(const Constant(false))();
}

class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text()();

  TextColumn get type => text()();

  TextColumn get level => text()();

  IntColumn get estimatedMinutes => integer()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId => integer()();

  IntColumn get exerciseId => integer()();

  // NUEVO CAMPO
  IntColumn get sectionId => integer()();

  IntColumn get orderIndex => integer()();

  IntColumn get sets => integer()();

  IntColumn get reps => integer()();

  RealColumn get weight => real()();

  IntColumn get durationSeconds => integer()();

  IntColumn get restSeconds => integer()();
}

@DriftDatabase(
  tables: [
    Categories,
    Equipment,
    DifficultyLevels,
    MovementPatterns,
    WorkoutSections,
    MuscleGroups,
    ExerciseTags,
    ExerciseTagRelations,
    Exercises,
    Workouts,
    WorkoutExercises,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  Future<int> insertExercise(ExercisesCompanion exercise) {
    return into(exercises).insert(exercise);
  }

  Future<List<Exercise>> getAllExercises() {
    return select(exercises).get();
  }

  Future<void> deleteAllExercises() {
    return delete(exercises).go();
  }
}

class WorkoutSections extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get orderIndex => integer()();
}

class MuscleGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class ExerciseTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class ExerciseTagRelations extends Table {
  IntColumn get exerciseId => integer()();
  IntColumn get tagId => integer()();

  @override
  Set<Column> get primaryKey => {exerciseId, tagId};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'vida_asistente.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
