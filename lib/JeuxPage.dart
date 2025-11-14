import 'package:flutter/material.dart';
import 'pages/letters_page.dart';
import 'pages/numbers_page.dart';
import 'pages/puzzle_page.dart';
import 'pages/memory_game_page.dart';
import 'widgets/game_card.dart';

void main() {
  runApp(const JeuxEducatifApp());
}

class JeuxEducatifApp extends StatelessWidget {
  const JeuxEducatifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jeux éducatif',
      home: const PageJeux(),
    );
  }
}

class PageJeux extends StatelessWidget {
  const PageJeux({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF6EA),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // En-tête
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    const Text(
                      'إلعب معنا',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                      ),
                    ),


                  ],
                ),
              ),

              // Grille des jeux (2x2)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.57,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      GameCard(
                        title: 'لعبة الحروف',
                        imagePath: 'assets/images/letters.png',
                        color: const Color(0xFFFFD4E5),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LettersPage(),
                            ),
                          );
                        },
                      ),
                      GameCard(
                        title: 'لعبة الأرقام',
                        imagePath: 'assets/images/numbers.png',
                        color: const Color(0xFFCCE2F8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PageNumbersPage(),
                            ),
                          );
                        },
                      ),
                      GameCard(
                        title: 'لعبة بازل',
                        imagePath: 'assets/images/puzzle.png',
                        color: const Color(0xFFFAE2C3),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PuzzlePage(),
                            ),
                          );
                        },
                      ),
                      GameCard(
                        title: 'لعبة الذاكرة',
                        imagePath: 'assets/images/p1.png',
                        color: const Color(0xFFB7F6B6),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MemoryGamePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
