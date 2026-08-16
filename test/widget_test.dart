// Smoke test básico de Vida Asistente.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vida_asistente/app/app.dart';

void main() {
  testWidgets('La app arranca y muestra el saludo del dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: VidaAsistenteApp()),
    );
    await tester.pump();

    expect(find.text('Hola Danny 👋'), findsOneWidget);
  });
}
