// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_compras_online/main.dart'; // Corrigida a importação

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Encontra o widget MyApp.
    await tester.pumpWidget(const MyApp());

    // Encontra o texto '0'.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Encontra o botão de incrementar e simula um clique.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica se o contador foi incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
