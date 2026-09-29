import 'package:flutter/material.dart';

import '../../core/widgets/workout_timer.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temporizador')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: WorkoutTimer()),
      ),
    );
  }
}
