import 'package:flutter/material.dart';
import 'pages/letters_page.dart';
import 'pages/numbers_page.dart';
import 'pages/puzzle_page.dart';
import 'pages/memory_game_page.dart';
import 'widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const JeuxEducatifApp());


}

class JeuxEducatifApp extends StatelessWidget {
  const JeuxEducatifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ألعاب تعليمية',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Amiri',
        useMaterial3: true,
      ),
      home: const PageJeux(),
      // Routes définies pour une navigation plus propre
      routes: {
        '/letters': (context) => const LettersPage(),
        '/numbers': (context) => const PageNumbersPage(),
        '/puzzle': (context) => const PuzzlePage(),
        '/memory': (context) => const MemoryGamePage(),
      },
    );
  }
}

class PageJeux extends StatelessWidget {
  const PageJeux({super.key});

  // Liste des jeux pour une meilleure maintenabilité
  static final List<GameItem> games = [
    GameItem(
      title: 'لعبة الحروف',
      imagePath: 'assets/images/letters.png',
      color: Color(0xFFFFD4E5),
      route: '/letters',
    ),
    GameItem(
      title: 'لعبة الأرقام',
      imagePath: 'assets/images/numbers.png',
      color: Color(0xFFCCE2F8),
      route: '/numbers',
    ),
    GameItem(
      title: 'لعبة بازل',
      imagePath: 'assets/images/puzzle.png',
      color: Color(0xFFFAE2C3),
      route: '/puzzle',
    ),
    GameItem(
      title: 'لعبة الذاكرة',
      imagePath: 'assets/images/p1.png',
      color: Color(0xFFB7F6B6),
      route: '/memory',
    ),
  ];

  void _navigateToGame(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

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
              // En-tête amélioré
              _buildHeader(),

              // Description
              _buildDescription(),

              // Grille des jeux
              _buildGamesGrid(context),

              // Espace en bas
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'إلعب معنا',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
              color: Color(0xFF2D5A78),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر اللعبة التي تريدها',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Amiri',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'تعلم من خلال اللعب مع هذه الألعاب التعليمية الممتعة',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontFamily: 'Amiri',
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildGamesGrid(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75, // Ratio amélioré
          ),
          physics: const BouncingScrollPhysics(),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return GameCard(
              title: game.title,
              imagePath: game.imagePath,
              color: game.color,
              onTap: () => _navigateToGame(context, game.route),
            );
          },
        ),
      ),
    );
  }
}

// Classe helper pour gérer les données des jeux
class GameItem {
  final String title;
  final String imagePath;
  final Color color;
  final String route;

  const GameItem({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.route,
  });
}