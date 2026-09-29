import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_storage_provider.dart';

/// Primera pantalla que ve un usuario nuevo: pide su nombre para
/// personalizar la app. Una vez guardado, VidaAsistenteApp cambia
/// automáticamente a HomePage (no hace falta navegar manualmente).
class NameOnboardingPage extends ConsumerStatefulWidget {
  const NameOnboardingPage({super.key});

  @override
  ConsumerState<NameOnboardingPage> createState() =>
      _NameOnboardingPageState();
}

class _NameOnboardingPageState extends ConsumerState<NameOnboardingPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _controller.text.trim();

    await ref.read(appStorageProvider).setUserName(name);
    ref.read(userNameProvider.notifier).state = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/branding/logo antia.png",
                      height: 140,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "¿Cómo te llamas?",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Así personalizamos tu ANTIA RX.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: "Tu nombre",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Escribe tu nombre para continuar";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text("Comenzar"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
