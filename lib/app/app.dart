import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_page.dart';
import 'theme.dart';

class VidaAsistenteApp extends StatelessWidget {
  const VidaAsistenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vida Asistente',
      theme: AppTheme.light,
      home: const DashboardPage(),
    );
  }
}