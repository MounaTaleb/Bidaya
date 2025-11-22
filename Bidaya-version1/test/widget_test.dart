import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importe ton main.dart et toutes les pages utilisées
import 'package:bidaya/main.dart';
import 'package:bidaya/JeuxPage.dart';

import 'package:bidaya/pages/letters_page.dart';
import 'package:bidaya/pages/numbers_page.dart';
import 'package:bidaya/pages/puzzle_page.dart';
import 'package:bidaya/pages/memory_game_page.dart';

void main() {
  testWidgets('PageJeux displays all game titles', (WidgetTester tester) async {
    await tester.pumpWidget(const JeuxEducatifApp());

    expect(find.text('لعبة الحروف'), findsOneWidget);
    expect(find.text('لعبة الأرقام'), findsOneWidget);
    expect(find.text('لعبة بازل'), findsOneWidget);
    expect(find.text('لعبة الذاكرة'), findsOneWidget);
  });

  testWidgets('Navigates to LettersPage when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const JeuxEducatifApp());

    await tester.tap(find.text('لعبة الحروف'));
    await tester.pumpAndSettle();

    expect(find.byType(LettersPage), findsOneWidget);
  });

  testWidgets('Navigates to NumbersPage when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const JeuxEducatifApp());

    await tester.tap(find.text('لعبة الأرقام'));
    await tester.pumpAndSettle();

    expect(find.byType(PageNumbersPage), findsOneWidget);
  });

  // Tu peux ajouter des tests similaires pour PuzzlePage et MemoryGamePage
}
