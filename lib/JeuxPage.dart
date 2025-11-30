// main.dart - Page Jeux Éducatifs
import 'package:flutter/material.dart';
import 'pages/letters_page.dart';
import 'pages/numbers_page.dart';
import 'pages/puzzle_page.dart';
import 'pages/memory_game_page.dart';
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
        fontFamily: 'Cairo',
        useMaterial3: true,
      ),
      home: const PageJeux(),
    );
  }
}

class PageJeux extends StatefulWidget {
  const PageJeux({super.key});

  @override
  State<PageJeux> createState() => _PageJeuxState();
}

class _PageJeuxState extends State<PageJeux> with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;

  static final List<GameItem> games = [
    GameItem(
      title: 'لعبة الحروف',
      subtitle: '🔤 تعلم الحروف',
      imagePath: 'assets/images/letters.png',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFB3D9), Color(0xFFFFCCE5)],
      ),
      icon: Icons.text_fields_rounded,
      page: const LettersPage(),
    ),
    GameItem(
      title: 'لعبة الأرقام',
      subtitle: '🔢 تعلم الأرقام',
      imagePath: 'assets/images/numbers.png',
      gradient: const LinearGradient(
        colors: [Color(0xFFB3E0F2), Color(0xFFCCEBF7)],
      ),
      icon: Icons.numbers_rounded,
      page: const PageNumbersPage(),
    ),
    GameItem(
      title: 'لعبة بازل',
      subtitle: '🧩 حل الألغاز',
      imagePath: 'assets/images/puzzle.png',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF4A3), Color(0xFFFFF9C4)],
      ),
      icon: Icons.extension_rounded,
      page: const PuzzlePage(),
    ),
    GameItem(
      title: 'لعبة الذاكرة',
      subtitle: '🧠 قوة الذاكرة',
      imagePath: 'assets/images/p1.png',
      gradient: const LinearGradient(
        colors: [Color(0xFFA5D6A7), Color(0xFFBDE6BF)],
      ),
      icon: Icons.psychology_rounded,
      page: const MemoryGamePage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bubbleAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  void _navigateToGame(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // Fond dégradé moderne
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFF5F9),
                    Color(0xFFFFE8F3),
                    Color(0xFFE3F2FD),
                    Color(0xFFFFFDE7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Bulles décoratives animées
            AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: 100 + _bubbleAnimation.value,
                      left: 30,
                      child: _buildCircle(80, const Color(0xFFFFB3D9), 0.25),
                    ),
                    Positioned(
                      top: 180 - _bubbleAnimation.value,
                      right: 50,
                      child: _buildCircle(60, const Color(0xFFB3E0F2), 0.3),
                    ),
                    Positioned(
                      bottom: 180 + _bubbleAnimation.value,
                      left: 40,
                      child: _buildCircle(70, const Color(0xFFFFF59D), 0.25),
                    ),
                    Positioned(
                      bottom: 120 - _bubbleAnimation.value,
                      right: 30,
                      child: _buildCircle(65, const Color(0xFFA5D6A7), 0.25),
                    ),
                  ],
                );
              },
            ),

            // Contenu principal
            SafeArea(
              child: Column(
                children: [
                  // Header moderne et élégant
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           
                            const SizedBox(width: 15),
                            const Text(
                              'إلعب معنا',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF5C546A),
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: const Color(0xFFFF6B9D).withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            '🌟 اختر اللعبة المفضلة لديك 🌟',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5C546A),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Grille de jeux
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];
                          return _buildModernGameCard(
                            context,
                            game.title,
                            game.subtitle,
                            game.gradient,
                            game.imagePath,
                            game.icon,
                            () => _navigateToGame(context, game.page),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernGameCard(
    BuildContext context,
    String title,
    String subtitle,
    LinearGradient gradient,
    String imagePath,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.colors[0].withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Cercles décoratifs
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Contenu principal
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Zone d'image
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          imagePath,
                          width: 85,
                          height: 85,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              icon,
                              size: 50,
                              color: gradient.colors[0],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Zone de texte
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF5C546A),
                            height: 1.1,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5C546A).withOpacity(0.7),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'العب الآن',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF5C546A),
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.play_arrow_rounded,
                                size: 14,
                                color: gradient.colors[0],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class GameItem {
  final String title;
  final String subtitle;
  final String imagePath;
  final LinearGradient gradient;
  final IconData icon;
  final Widget page;

  const GameItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.gradient,
    required this.icon,
    required this.page,
  });
}
