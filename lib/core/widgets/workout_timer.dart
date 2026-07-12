import 'dart:async';
import 'package:flutter/material.dart';

class WorkoutTimer extends StatefulWidget {
  const WorkoutTimer({super.key});

  @override
  State<WorkoutTimer> createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  int seconds = 0;
  Timer? timer;
  bool running = false;

  void start() {
    if (running) return;

    running = true;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        seconds++;
      });
    });
  }

  void stop() {
    timer?.cancel();

    setState(() {
      running = false;
    });
  }

  void reset() {
    timer?.cancel();

    setState(() {
      running = false;
      seconds = 0;
    });
  }

  String get time {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');

    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(onPressed: start, child: const Text("Iniciar")),
                FilledButton(onPressed: stop, child: const Text("Pausar")),
                FilledButton(onPressed: reset, child: const Text("Reset")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
