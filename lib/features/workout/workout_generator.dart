import 'dart:math';

import '../../database/app_database.dart';
import '../../repositories/exercise_repository.dart';

import 'workout_model.dart';

import 'generators/warmup_generator.dart';
import 'generators/strength_generator.dart';
import 'generators/skill_generator.dart';
import 'generators/cooldown_generator.dart';

import 'generators/amrap_generator.dart';
import 'generators/emom_generator.dart';
import 'generators/for_time_generator.dart';
import 'generators/chipper_generator.dart';
import 'generators/rounds_generator.dart';

import 'generators/wod_format.dart';
import 'generators/wod_format_generator.dart';

class WorkoutGenerator {
  final ExerciseRepository repository;

  WorkoutGenerator(this.repository) {
    warmupGenerator = WarmupGenerator();
    strengthGenerator = StrengthGenerator();
    skillGenerator = SkillGenerator();
    cooldownGenerator = CooldownGenerator();

    amrapGenerator = AmrapGenerator(repository);
    emomGenerator = EmomGenerator(repository);
    forTimeGenerator = ForTimeGenerator(repository);
    chipperGenerator = ChipperGenerator(repository);
    roundsGenerator = RoundsGenerator(repository);

    wodFormatGenerator = WodFormatGenerator();
  }

  final Random random = Random();

  late final WarmupGenerator warmupGenerator;
  late final StrengthGenerator strengthGenerator;
  late final SkillGenerator skillGenerator;
  late final CooldownGenerator cooldownGenerator;

  late final AmrapGenerator amrapGenerator;
  late final EmomGenerator emomGenerator;
  late final ForTimeGenerator forTimeGenerator;
  late final ChipperGenerator chipperGenerator;
  late final RoundsGenerator roundsGenerator;

  late final WodFormatGenerator wodFormatGenerator;

  /// Evita repetir ejercicios
  final Set<int> usedExercises = {};

  WorkoutExerciseModel buildExercise(Exercise exercise, String section) {
    switch (section) {
      case "Warm Up":
        return warmupGenerator.generate(exercise);

      case "Strength":
        return strengthGenerator.generate(exercise);

      case "Skill":
        return skillGenerator.generate(exercise);

      case "Cool Down":
        return cooldownGenerator.generate(exercise);

      case "WOD":
        return WorkoutExerciseModel(
          name: exercise.name,
          reps: "${8 + random.nextInt(13)}",
        );

      default:
        return WorkoutExerciseModel(name: exercise.name);
    }
  }

  List<WorkoutExerciseModel> pickExercises(
    List<Exercise> source,
    int amount,
    String section,
  ) {
    source.shuffle(random);

    final selected = <WorkoutExerciseModel>[];

    for (final exercise in source) {
      if (usedExercises.contains(exercise.id)) continue;

      usedExercises.add(exercise.id);

      selected.add(buildExercise(exercise, section));

      if (selected.length == amount) {
        break;
      }
    }

    return selected;
  }

  Future<WorkoutSectionModel> generateWod() async {
    final format = wodFormatGenerator.randomFormat();

    switch (format) {
      case WodFormat.amrap:
        return await amrapGenerator.generate();

      case WodFormat.emom:
        return await emomGenerator.generate();

      case WodFormat.forTime:
        return await forTimeGenerator.generate();

      case WodFormat.chipper:
        return await chipperGenerator.generate();

      case WodFormat.rounds:
        return await roundsGenerator.generate();
    }
  }

  Future<WorkoutModel> generate() async {
    usedExercises.clear();

    final warmups = await repository.getWarmupExercises();
    final strengths = await repository.getStrengthExercises();
    final skills = await repository.getSkillExercises();
    final cooldowns = await repository.getCooldownExercises();

    final wodSection = await generateWod();

    return WorkoutModel(
      title: "CrossFit del Día",
      type: "CrossFit",
      sections: [
        WorkoutSectionModel(
          name: "Warm Up",
          exercises: pickExercises(warmups, 3, "Warm Up"),
        ),

        WorkoutSectionModel(
          name: "Strength",
          exercises: pickExercises(strengths, 2, "Strength"),
        ),

        WorkoutSectionModel(
          name: "Skill",
          exercises: pickExercises(skills, 2, "Skill"),
        ),

        wodSection,

        WorkoutSectionModel(
          name: "Cool Down",
          exercises: pickExercises(cooldowns, 2, "Cool Down"),
        ),
      ],
    );
  }
}
