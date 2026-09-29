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
  bool _isLoading = true;

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
    _loadInitialWorkout();
  }

  Future<void> _loadInitialWorkout() async {
    try {
      final customWodRepo = ref.read(customWodRepositoryProvider);
      final existingWod = await customWodRepo.getTodayCustomWod();

      if (existingWod != null && _isToday(_selectedDate)) {
        // Si hay un WOD personalizado para hoy, cárgalo
        setState(() {
          _titleController.text = existingWod.title;
          sections = existingWod.sections
              .map((section) => [...section.exercises])
              .toList();
        });
      } else {
        // Si no, carga el WOD generado automáticamente para hoy
        final repository = ref.read(exerciseRepositoryProvider);
        final generatedWod =
            await generateWorkoutForDate(repository, _selectedDate);
        setState(() {
          _titleController.text = generatedWod.title;
          sections = generatedWod.sections
              .map((section) => [...section.exercises])
              .toList();
        });
      }
    } catch (e) {
      print('Error cargando WOD: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  void _updateExerciseInSection(
    int sectionIdx,
    int exerciseIdx,
    WorkoutExerciseModel updatedExercise,
  ) {
    setState(() {
      sections[sectionIdx][exerciseIdx] = updatedExercise;
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      // Si es una fecha diferente a hoy, mostrar opciones
      if (!_isToday(picked)) {
        _showDateOptions();
      } else {
        // Si vuelve a hoy, recargar el WOD de hoy
        _loadInitialWorkout();
      }
    }
  }

  Future<void> _showDateOptions() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear WOD para esta fecha'),
        content: const Text('¿Cómo quieres empezar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _loadGeneratedForDate();
            },
            child: const Text('Partir del generado'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _clearSections();
            },
            child: const Text('En blanco'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadGeneratedForDate() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final repository = ref.read(exerciseRepositoryProvider);
      final generatedWod =
          await generateWorkoutForDate(repository, _selectedDate);
      setState(() {
        _titleController.text = generatedWod.title;
        sections = generatedWod.sections
            .map((section) => [...section.exercises])
            .toList();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSections() {
    setState(() {
      sections = [[], [], [], []];
      _titleController.text = 'Mi WOD Custom';
    });
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
          SnackBar(
            content: Text(
              _isToday(_selectedDate)
                  ? 'WOD guardado para hoy!'
                  : 'WOD guardado para ${_selectedDate.day}/${_selectedDate.month}',
            ),
          ),
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
        title: const Text('Editar WOD'),
        backgroundColor: AppTheme.background,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}${_isToday(_selectedDate) ? ' (Hoy)' : ''}',
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
                      onRemoveExercise: (idx) =>
                          _removeExerciseFromSection(i, idx),
                      onUpdateExercise: (idx, exercise) =>
                          _updateExerciseInSection(i, idx, exercise),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveWod,
                      icon: const Icon(Icons.save),
                      label: Text(
                        _isToday(_selectedDate)
                            ? 'Guardar para hoy'
                            : 'Guardar para ${_selectedDate.day}/${_selectedDate.month}',
                      ),
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
  final Function(int, WorkoutExerciseModel) onUpdateExercise;

  const _SectionBuilder({
    required this.sectionIndex,
    required this.sectionName,
    required this.exercises,
    required this.onAddExercise,
    required this.onRemoveExercise,
    required this.onUpdateExercise,
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
                  onUpdate: (updated) => onUpdateExercise(i, updated),
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
  final Function(WorkoutExerciseModel) onUpdate;

  const _ExerciseListItem({
    required this.exercise,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  State<_ExerciseListItem> createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<_ExerciseListItem> {
  late TextEditingController _setsCtrl;
  late TextEditingController _repsCtrl;
  late TextEditingController _weightCtrl;
  bool _isEditing = false;

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

  void _saveChanges() {
    final updated = WorkoutExerciseModel(
      name: widget.exercise.name,
      equipment: widget.exercise.equipment,
      sets: _setsCtrl.text.isEmpty ? null : _setsCtrl.text,
      reps: _repsCtrl.text.isEmpty ? null : _repsCtrl.text,
      weight: _weightCtrl.text.isEmpty ? null : _weightCtrl.text,
      duration: widget.exercise.duration,
      distance: widget.exercise.distance,
      notes: widget.exercise.notes,
    );
    widget.onUpdate(updated);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.accent),
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: _saveChanges,
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      );
    }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exercise.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (widget.exercise.sets != null ||
                        widget.exercise.reps != null ||
                        widget.exercise.weight != null)
                      Text(
                        '${widget.exercise.sets ?? ''}x${widget.exercise.reps ?? ''} @ ${widget.exercise.weight ?? ''}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.red),
                    onPressed: widget.onRemove,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
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
