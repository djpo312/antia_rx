import 'package:drift/drift.dart';
import 'connection/connection.dart' as impl;
import '../features/exercises/exercise_list_item.dart';

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

  IntColumn get categoryId => integer().references(Categories, #id)();

  IntColumn get equipmentId => integer().references(Equipment, #id)();

  IntColumn get difficultyId => integer().references(DifficultyLevels, #id)();

  IntColumn get movementPatternId =>
      integer().references(MovementPatterns, #id)();

  TextColumn get instructions => text()();

  TextColumn get videoUrl => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();

  BoolColumn get isMobility => boolean().withDefault(const Constant(false))();

  BoolColumn get isStrength => boolean().withDefault(const Constant(false))();

  BoolColumn get isSkill => boolean().withDefault(const Constant(false))();

  BoolColumn get isWod => boolean().withDefault(const Constant(false))();

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
  int get schemaVersion => 2;
  Future<int> insertExercise(ExercisesCompanion exercise) {
    return into(exercises).insert(exercise);
  }

  Future<List<Exercise>> getAllExercises() {
    return select(exercises).get();
  }

  Future<void> deleteAllExercises() {
    return delete(exercises).go();
  }

  Future<Category?> getCategoryByName(String name) {
    return (select(
      categories,
    )..where((t) => t.name.equals(name))).getSingleOrNull();
  }

  Future<EquipmentData?> getEquipmentByName(String name) {
    return (select(
      equipment,
    )..where((t) => t.name.equals(name))).getSingleOrNull();
  }

  Future<DifficultyLevel?> getDifficultyByName(String name) {
    return (select(
      difficultyLevels,
    )..where((t) => t.name.equals(name))).getSingleOrNull();
  }

  Future<MovementPattern?> getMovementByName(String name) {
    return (select(
      movementPatterns,
    )..where((t) => t.name.equals(name))).getSingleOrNull();
  }

  Future<void> debugCatalogs() async {
    print("===== CATEGORIAS =====");
    print(await select(categories).get());

    print("===== EQUIPOS =====");
    print(await select(equipment).get());

    print("===== DIFICULTADES =====");
    print(await select(difficultyLevels).get());

    print("===== MOVIMIENTOS =====");
    print(await select(movementPatterns).get());
  }

  // Obtener todos los ejercicios
  // Future<List<Exercise>> getExercises() {
  //   return (select(
  //     exercises,
  //)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  //  }

  // Buscar ejercicios
  Future<List<Exercise>> searchExercises(String text) {
    return (select(exercises)
          ..where((tbl) => tbl.name.like('%$text%') | tbl.code.like('%$text%'))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  // Obtener un ejercicio por id
  Future<List<ExerciseListItem>> getExercises() async {
    final query = select(exercises).join([
      innerJoin(categories, categories.id.equalsExp(exercises.categoryId)),
      innerJoin(equipment, equipment.id.equalsExp(exercises.equipmentId)),
      innerJoin(
        difficultyLevels,
        difficultyLevels.id.equalsExp(exercises.difficultyId),
      ),
      innerJoin(
        movementPatterns,
        movementPatterns.id.equalsExp(exercises.movementPatternId),
      ),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final exercise = row.readTable(exercises);
      final category = row.readTable(categories);
      final equip = row.readTable(equipment);
      final difficulty = row.readTable(difficultyLevels);
      final movement = row.readTable(movementPatterns);

      return ExerciseListItem(
        id: exercise.id,
        code: exercise.code,
        name: exercise.name,
        description: exercise.description,
        category: category.name,
        equipment: equip.name,
        difficulty: difficulty.name,
        movement: movement.name,
      );
    }).toList();
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

LazyDatabase _openConnection() => impl.openConnection();
