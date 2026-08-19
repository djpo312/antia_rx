import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_storage_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
      text: ref.read(userNameProvider) ?? "",
    );

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar nombre"),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: "Tu nombre"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text("Guardar"),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty) return;

    await ref.read(appStorageProvider).setUserName(newName);
    ref.read(userNameProvider.notifier).state = newName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider) ?? "";
    final weeklyWods = ref.watch(weeklyCompletedWodsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : "?",
              style: const TextStyle(fontSize: 32),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: TextButton.icon(
              onPressed: () => _editName(context, ref),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text("Editar nombre"),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: const Text("WODs completados esta semana"),
              trailing: Text(
                "$weeklyWods",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
