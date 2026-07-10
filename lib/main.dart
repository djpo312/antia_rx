import 'package:flutter/material.dart';
import 'features/home/home_page.dart';

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
      home: const HomePage(),
    );
  }
}