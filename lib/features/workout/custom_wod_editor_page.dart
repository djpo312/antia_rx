import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../providers/exercise_repository_provider.dart';
import '../../repositories/custom_wod_repository.dart';
import 'workout_model.dart';
import 'workout_provider.dart';

class CustomWodEditorPage extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const CustomWodEditorPage({Key? key, this.initialDate}) : super(key: key);

  @override
  ConsumerState<CustomWodEditorPage> createState() =>
      _CustomWodEditorPageState();
}

class _CustomWodEditorPageState extends ConsumerState<CustomWodEditorPage> {
  late List<List<WorkoutExerciseModel>> sections;
  final _titleController = TextEditingController(text: 'Mi WOD Custom');
  late DateTime _selectedDate;

  final _sectionNames = [
    'Calentamiento',
    'Entrenamiento',
    'Fuerza',
    'Enfriamiento'
  ];

  @override
  void initState() {
    super.initState();
    sections = [[], [], [], []];
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addExerciseToSection(int sectionIdx, WorkoutExerciseModel exercise) {
    setState(() {
      sections[sectionIdx].add(exercise);
    });
  }

  void _removeExerciseFromSection(int sectionIdx, int exerciseIdx) {
    setState(() {
      sections[sectionIdx].removeAt(exerciseIdx);
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2099),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveWod() async {
    if (sections.every((s) => s.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ejercicio')),
      );
      return;
    }

    // Construye el modelo de WOD
    final workoutSections = sections
        .asMap()
        .entries
        .map((entry) {
          final idx = entry.key;
          final exercises = entry.value;
          return WorkoutSectionModel(
            name: _sectionNames[idx],
            subtitle: null,
            durationMinutes: null,
            exercises: exercises,
          );
        })
        .where((s) => s.exercises.isNotEmpty)
        .toList();

    final workout = WorkoutModel(
      title: _titleController.text,
      type: 'crossfit',
      sections: workoutSections,
    );

    // Guarda en la BD
    try {
      final customWodRepo = ref.read(customWodRepositoryProvider);
      await customWodRepo.saveCustomWodForDate(workout, _selectedDate);

      // Invalida el provider para que recargue el WOD (si es hoy)
      if (_isToday(_selectedDate)) {
        ref.invalidate(dailyWorkoutProvider);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WOD guardado para hoy!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear WOD Custom'),
        backgroundColor: AppTheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Nombre del WOD',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Fecha'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < 4; i++)
              _SectionBuilder(
                sectionIndex: i,
                sectionName: _sectionNames[i],
                exercises: sections[i],
                onAddExercise: (exercise) =>
                    _addExerciseToSection(i, exercise),
                onRemoveExercise: (idx) => _removeExerciseFromSection(i, idx),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveWod,
                icon: const Icon(Icons.save),
                label: const Text('Guardar para hoy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionBuilder extends ConsumerWidget {
  final int sectionIndex;
  final String sectionName;
  final List<WorkoutExerciseModel> exercises;
  final Function(WorkoutExerciseModel) onAddExercise;
  final Function(int) onRemoveExercise;

  const _SectionBuilder({
    required this.sectionIndex,
    required this.sectionName,
    required this.exercises,
    required this.onAddExercise,
    required this.onRemoveExercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (exercises.isEmpty)
              Center(
                child: Text(
                  'Sin ejercicios',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
              )
            else
              for (int i = 0; i < exercises.length; i++)
                _ExerciseListItem(
                  exercise: exercises[i],
                  onRemove: () => onRemoveExercise(i),
                ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: Text('Agregar ejercicio a $sectionName'),
                onPressed: () async {
                  final exercise = await showDialog<WorkoutExerciseModel>(
                    context: context,
                    builder: (ctx) => _ExercisePickerDialog(
                      sectionIndex: sectionIndex,
                    ),
                  );
                  if (exercise != null) {
                    onAddExercise(exercise);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseListItem extends StatefulWidget {
  final WorkoutExerciseModel exercise;
  final VoidCallback onRemove;

  const _ExerciseListItem({
    required this.exercise,
    required this.onRemove,
  });

  @override
  State<_ExerciseListItem> createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<_ExerciseListItem> {
  late TextEditingController _setsCtrl;
  late TextEditingController _repsCtrl;
  late TextEditingController _weightCtrl;

  @override
  void initState() {
    super.initState();
    _setsCtrl = TextEditingController(text: widget.exercise.sets ?? '');
    _repsCtrl = TextEditingController(text: widget.exercise.reps ?? '');
    _weightCtrl = TextEditingController(text: widget.exercise.weight ?? '');
  }

  @override
  void dispose() {
    _setsCtrl.dispose();
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.exercise.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: widget.onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _setsCtrl,
                  decoration: InputDecoration(
                    labelText: 'Sets',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _repsCtrl,
                  decoration: InputDecoration(
                    labelText: 'Reps',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _weightCtrl,
                  decoration: InputDecoration(
                    labelText: 'Peso (kg)',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExercisePickerDialog extends ConsumerWidget {
  final int sectionIndex;

  const _ExercisePickerDialog({required this.sectionIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseRepoAsync = ref.watch(exerciseRepositoryProvider);

    return AlertDialog(
      title: const Text('Selecciona un ejercicio'),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder(
          future: exerciseRepoAsync.getExercisesByCategory('CrossFit'),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No hay ejercicios disponibles'),
              );
            }

            final exercises = snapshot.data!;

            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (ctx, idx) {
                final exercise = exercises[idx];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: exercise.description.isNotEmpty
                      ? Text(
                          exercise.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(
                      context,
                      WorkoutExerciseModel(
                        name: exercise.name,
                        equipment: null,
                        sets: '3',
                        reps: '10',
                        weight: null,
                        duration: null,
                        distance: null,
                        notes: exercise.description.isNotEmpty
                            ? exercise.description
                            : null,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
