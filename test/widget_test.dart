import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bidaya/main.dart';
import 'package:bidaya/JeuxPage.dart';
import 'package:bidaya/pages/letters_page.dart';
import 'package:bidaya/pages/numbers_page.dart';
import 'package:bidaya/widgets/game_card.dart'; // Import ajouté


void main() {
  testWidgets('PageJeux displays all game titles', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PageJeux()));
    await tester.pumpAndSettle();

    expect(find.text('لعبة الحروف'), findsOneWidget);
    expect(find.text('لعبة الأرقام'), findsOneWidget);
    expect(find.text('لعبة بازل'), findsOneWidget);
    expect(find.text('لعبة الذاكرة'), findsOneWidget);
  });

  testWidgets('PageJeux displays header and description', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PageJeux()));
    await tester.pumpAndSettle();

    expect(find.text('إلعب معنا'), findsOneWidget);
    expect(find.text('اختر اللعبة التي تريدها'), findsOneWidget);
  });

  testWidgets('Navigates to LettersPage when letters game is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PageJeux(),
        routes: {
          '/letters': (context) => const LettersPage(),
        },
      ),
    );

    await tester.pumpAndSettle();

    final lettersFinder = find.text('لعبة الحروف');
    expect(lettersFinder, findsOneWidget);

    await tester.tap(lettersFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(LettersPage), findsOneWidget);
  });

  testWidgets('Has 4 game cards', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PageJeux()));
    await tester.pumpAndSettle();

    expect(find.byType(GameCard), findsNWidgets(4));
  });

  testWidgets('Game cards are tappable', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PageJeux(),
        routes: {
          '/numbers': (context) => const PageNumbersPage(),
        },
      ),
    );

    await tester.pumpAndSettle();

    final numbersFinder = find.text('لعبة الأرقام');
    expect(numbersFinder, findsOneWidget);

    await tester.tap(numbersFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Vérifier que la navigation a fonctionné
    expect(find.byType(PageNumbersPage), findsOneWidget);
  });
}