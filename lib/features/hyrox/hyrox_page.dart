import 'package:flutter/material.dart';

class HyroxPage extends StatelessWidget {
  const HyroxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hyrox")),
      body: const Center(
        child: Text(
          "Entrenamientos de Hyrox",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
