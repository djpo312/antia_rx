// Smoke test básico de Vida Asistente.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vida_asistente/app/app.dart';
import 'package:vida_asistente/core/services/app_storage_service.dart';
import 'package:vida_asistente/providers/app_storage_provider.dart';

void main() {
  testWidgets('La app arranca y muestra el saludo del dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStorageProvider.overrideWithValue(AppStorageService.empty()),
          userNameProvider.overrideWith((ref) => "Danny"),
        ],
        child: const VidaAsistenteApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Hola, Danny'), findsOneWidget);
  });
}
