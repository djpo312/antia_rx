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
  /// [seed] permite generar un entrenamiento reproducible (ej. el mismo
  /// WOD durante todo el día, en base a la fecha). Si se omite, cada
  /// llamada a [generate] produce un entrenamiento distinto.
  WorkoutGenerator(this.repository, {int? seed})
    : random = seed != null ? Random(seed) : Random() {
    warmupGenerator = WarmupGenerator(random: random);
    strengthGenerator = StrengthGenerator(random: random);
    skillGenerator = SkillGenerator(random: random);
    cooldownGenerator = CooldownGenerator(random: random);

    amrapGenerator = AmrapGenerator(repository, random: random);
    emomGenerator = EmomGenerator(repository, random: random);
    forTimeGenerator = ForTimeGenerator(repository, random: random);
    chipperGenerator = ChipperGenerator(repository, random: random);
    roundsGenerator = RoundsGenerator(repository, random: random);

    wodFormatGenerator = WodFormatGenerator(random: random);
  }

  final ExerciseRepository repository;
  final Random random;

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

  WorkoutExerciseModel buildExercise(
    Exercise exercise,
    String section,
    Map<int, String> equipmentNames,
  ) {
    final equipment = equipmentNames[exercise.equipmentId];

    switch (section) {
      case "Warm Up":
        return warmupGenerator.generate(exercise, equipment: equipment);

      case "Strength":
        return strengthGenerator.generate(exercise, equipment: equipment);

      case "Skill":
        return skillGenerator.generate(exercise, equipment: equipment);

      case "Cool Down":
        return cooldownGenerator.generate(exercise, equipment: equipment);

      case "WOD":
        return WorkoutExerciseModel(
          name: exercise.name,
          equipment: equipment,
          reps: "${8 + random.nextInt(13)}",
        );

      default:
        return WorkoutExerciseModel(name: exercise.name, equipment: equipment);
    }
  }

  List<WorkoutExerciseModel> pickExercises(
    List<Exercise> source,
    int amount,
    String section,
    Map<int, String> equipmentNames,
  ) {
    source.shuffle(random);

    final selected = <WorkoutExerciseModel>[];

    for (final exercise in source) {
      if (usedExercises.contains(exercise.id)) continue;

      usedExercises.add(exercise.id);

      selected.add(buildExercise(exercise, section, equipmentNames));

      if (selected.length == amount) {
        break;
      }
    }

    return selected;
  }

  /// Duración total que debe sumar el entrenamiento completo.
  static const int totalMinutes = 60;

  Future<WorkoutSectionModel> generateWod(
    int minutes,
    Map<int, String> equipmentNames,
  ) async {
    final format = wodFormatGenerator.randomFormat();

    switch (format) {
      case WodFormat.amrap:
        return await amrapGenerator.generate(minutes, equipmentNames);

      case WodFormat.emom:
        return await emomGenerator.generate(minutes, equipmentNames);

      case WodFormat.forTime:
        return await forTimeGenerator.generate(minutes, equipmentNames);

      case WodFormat.chipper:
        return await chipperGenerator.generate(minutes, equipmentNames);

      case WodFormat.rounds:
        return await roundsGenerator.generate(minutes, equipmentNames);
    }
  }

  Future<WorkoutModel> generate() async {
    usedExercises.clear();

    // Reparte los 60 minutos entre las ventanas del entrenamiento. El WOD
    // se queda con lo que sobra, para que la suma siempre dé el total.
    final warmupMinutes = 8 + random.nextInt(5); // 8-12
    final strengthMinutes = 12 + random.nextInt(7); // 12-18
    final skillMinutes = 8 + random.nextInt(5); // 8-12
    final cooldownMinutes = 5 + random.nextInt(4); // 5-8
    final wodMinutes =
        totalMinutes -
        (warmupMinutes + strengthMinutes + skillMinutes + cooldownMinutes);

    final equipmentNames = await repository.getEquipmentNames();

    final warmups = await repository.getWarmupExercises();
    final strengths = await repository.getStrengthExercises();
    final skills = await repository.getSkillExercises();
    final cooldowns = await repository.getCooldownExercises();

    final wodSection = await generateWod(wodMinutes, equipmentNames);

    return WorkoutModel(
      title: "CrossFit del Día",
      type: "CrossFit",
      sections: [
        WorkoutSectionModel(
          name: "Warm Up",
          durationMinutes: warmupMinutes,
          exercises: pickExercises(warmups, 3, "Warm Up", equipmentNames),
        ),

        WorkoutSectionModel(
          name: "Strength",
          durationMinutes: strengthMinutes,
          exercises: pickExercises(strengths, 2, "Strength", equipmentNames),
        ),

        WorkoutSectionModel(
          name: "Skill",
          durationMinutes: skillMinutes,
          exercises: pickExercises(skills, 2, "Skill", equipmentNames),
        ),

        wodSection,

        WorkoutSectionModel(
          name: "Cool Down",
          durationMinutes: cooldownMinutes,
          exercises: pickExercises(cooldowns, 2, "Cool Down", equipmentNames),
        ),
      ],
    );
  }
}
