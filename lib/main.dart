import 'package:flutter/material.dart';

void main() {
  runApp(const VidaAsistenteApp());
}

class VidaAsistenteApp extends StatelessWidget {
  const VidaAsistenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vida Asistente',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vida Asistente"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.fitness_center,
              size: 90,
            ),
            SizedBox(height: 20),
            Text(
              "Bienvenido",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tu asistente personal de entrenamiento",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}