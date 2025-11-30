// screens/games_menu_screen.dart
import 'package:flutter/material.dart';
import '../models/user_progress.dart';
import 'math_game_screen.dart';

class GamesMenuScreen extends StatelessWidget {
  final String category;
  final LevelProgress progress;

  const GamesMenuScreen({
    super.key,
    required this.category,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    String title = '';
    Color primaryColor = const Color(0xFF4CAF50);
    String backgroundImage = '';

    switch (category) {
      case 'math':
        title = 'الأرقام والحساب';
        primaryColor = const Color(0xFF4CAF50);
        backgroundImage = 'math_background';
        break;
      case 'countries':
        title = 'الدول والثقافات';
        primaryColor = const Color(0xFF2196F3);
        backgroundImage = 'countries_background';
        break;
      case 'puzzles':
        title = 'الألغاز والتفكير';
        primaryColor = const Color(0xFFFF9800);
        backgroundImage = 'puzzles_background';
        break;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A89CC), Color(0xFFB8E6FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec bouton retour
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF6A89CC)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Lapin et progression
              Expanded(
                child: Stack(
                  children: [
                    // Lapin personnage
                    Positioned(
                      top: 20,
                      right: 30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 60,
                          color: Color(0xFFFF6B8B),
                        ),
                      ),
                    ),

                    // Barre de progression
                    Positioned(
                      top: 160,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'تقدمك',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6A89CC),
                                  ),
                                ),
                                Text(
                                  '${progress.completedLevels}/12',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF6B8B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: progress.completedLevels / 12,
                              backgroundColor: const Color(0xFFE0E0E0),
                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                              minHeight: 12,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Grille des niveaux
                    Positioned(
                      top: 260,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            final levelNumber = index + 1;
                            final isUnlocked = levelNumber <= progress.currentLevel;
                            final isCompleted = levelNumber <= progress.completedLevels;

                            return LevelBubble(
                              levelNumber: levelNumber,
                              isUnlocked: isUnlocked,
                              isCompleted: isCompleted,
                              primaryColor: primaryColor,
                              onTap: isUnlocked
                                  ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MathGameScreen(
                                      gameType: _getGameTypeForLevel(levelNumber),
                                      title: 'المستوى $levelNumber',
                                      levelNumber: levelNumber,
                                    ),
                                  ),
                                );
                              }
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGameTypeForLevel(int level) {
    if (level <= 4) return 'addition';
    if (level <= 8) return 'subtraction';
    return 'large_numbers';
  }
}

class LevelBubble extends StatelessWidget {
  final int levelNumber;
  final bool isUnlocked;
  final bool isCompleted;
  final Color primaryColor;
  final VoidCallback? onTap;

  const LevelBubble({
    super.key,
    required this.levelNumber,
    required this.isUnlocked,
    required this.isCompleted,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted ? primaryColor : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isUnlocked ? primaryColor : const Color(0xFFCCCCCC),
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$levelNumber',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.white : primaryColor,
                ),
              ),
            ),

            // Étoile pour les niveaux complétés
            if (isCompleted)
              const Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
              ),

            // Cadenas pour les niveaux verrouillés
            if (!isUnlocked)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}