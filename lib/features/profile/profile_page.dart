import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_version.dart';
import '../../core/utils/spanish_date.dart';
import '../../providers/app_storage_provider.dart';
import '../workout/favorite_wod_detail_page.dart';

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
    final weeklyCrossfit = ref.watch(weeklyCompletedWodsProvider("crossfit"));
    final weeklyPosparto = ref.watch(weeklyCompletedWodsProvider("posparto"));
    final weeklyGym = ref.watch(weeklyCompletedWodsProvider("gym"));

    final favoriteCrossfit = ref
        .watch(favoriteWodDatesProvider("crossfit"))
        .map((date) => (date: date, category: "crossfit"))
        .toList();
    final favoritePosparto = ref
        .watch(favoriteWodDatesProvider("posparto"))
        .map((date) => (date: date, category: "posparto"))
        .toList();
    final favoriteGym = ref
        .watch(favoriteWodDatesProvider("gym"))
        .map((date) => (date: date, category: "gym"))
        .toList();
    final favorites = [...favoriteCrossfit, ...favoritePosparto, ...favoriteGym]
      ..sort((a, b) => b.date.compareTo(a.date));

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
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: const Text("CrossFit completados esta semana"),
                  trailing: Text(
                    "$weeklyCrossfit",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.child_friendly,
                    color: Colors.green,
                  ),
                  title: const Text("Gym Posparto completados esta semana"),
                  trailing: Text(
                    "$weeklyPosparto",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.sports_gymnastics,
                    color: Colors.green,
                  ),
                  title: const Text("Gimnasio completados esta semana"),
                  trailing: Text(
                    "$weeklyGym",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (favorites.isNotEmpty) ...[
            const SizedBox(height: 24),

            const Text(
              "WODs favoritos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Card(
              child: Column(
                children: [
                  for (final favorite in favorites)
                    ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                      ),
                      title: Text(formatSpanishDate(favorite.date)),
                      subtitle: Text(
                        switch (favorite.category) {
                          "posparto" => "Gym Posparto",
                          "gym" => "Gimnasio",
                          _ => "CrossFit",
                        },
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavoriteWodDetailPage(
                            date: favorite.date,
                            category: favorite.category,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          Center(
            child: Text(
              "ANTIA RX · v$appVersion",
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
