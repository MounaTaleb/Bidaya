<<<<<<< HEAD
// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bideya/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EducationalApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
=======
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
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c
