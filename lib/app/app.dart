import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/home/home_page.dart';
import '../features/onboarding/name_onboarding_page.dart';
import '../providers/app_storage_provider.dart';
import 'theme.dart';

class VidaAsistenteApp extends ConsumerWidget {
  const VidaAsistenteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ANTIA RX',
      theme: AppTheme.dark,
      // Sin nombre guardado -> onboarding. Apenas se guarda, este widget
      // se reconstruye solo y pasa a HomePage sin navegación manual.
      home: userName == null || userName.isEmpty
          ? const NameOnboardingPage()
          : const HomePage(),
    );
  }
}
