import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vida Asistente"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "👋 Hola, Danny",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "¿Qué quieres entrenar hoy?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: const [

                  _MenuCard(
                    icon: Icons.fitness_center,
                    title: "Generar\nWOD",
                  ),

                  _MenuCard(
                    icon: Icons.menu_book,
                    title: "Ejercicios",
                  ),

                  _MenuCard(
                    icon: Icons.history,
                    title: "Historial",
                  ),

                  _MenuCard(
                    icon: Icons.timer,
                    title: "Temporizador",
                  ),

                  _MenuCard(
                    icon: Icons.emoji_events,
                    title: "Mis PR",
                  ),

                  _MenuCard(
                    icon: Icons.settings,
                    title: "Configuración",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MenuCard({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}