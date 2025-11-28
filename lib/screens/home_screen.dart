// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'capitale/niveau_page.dart';
import 'math/math_nivrau_page.dart';
import 'science/science_niveau_page.dart';
import 'animaux/animaux_niveau_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Rose très clair et doux
      body: SafeArea(
        child: Column(
          children: [
            // Header mignon avec nuages et étoiles
            Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFB6C1), Color(0xFFFFE4E1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  // Nuages décoratifs
                  Positioned(
                    top: 20,
                    left: 30,
                    child: _buildCloud(),
                  ),
                  Positioned(
                    top: 40,
                    right: 50,
                    child: _buildCloud(),
                  ),
                  Positioned(
                    top: 60,
                    left: 100,
                    child: _buildCloud(),
                  ),

                  // Contenu principal
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'إلعب معنا',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            shadows: [
                              Shadow(
                                color: Colors.pink,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            '🎮 هيا نلعب ونتعلم معاً 🎮',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Lapin mignon en haut à droite
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '🐰',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Grille de catégories avec photos plus grandes
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Première ligne
                    Expanded(
                      child: Row(
                        children: [
                          // عواصم الدول
                          Expanded(
                            child: _buildCuteCategoryCard(
                              context,
                              'عواصم الدول',
                              '🌍 اكتشف العالم',
                              const Color(0xFF98E4D8), // Cyan clair
                              'assets/images/drapo.png',
                              Icons.flag,
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CapitaleNiveauPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          // إيقاظ علمي
                          Expanded(
                            child: _buildCuteCategoryCard(
                              context,
                              'إيقاظ علمي',
                              '🔬 استكشف العلوم',
                              const Color(0xFFB8E6D5), // Vert menthe
                              'assets/images/i9ath.png',
                              Icons.science,
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ScienceNiveauPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Deuxième ligne
                    Expanded(
                      child: Row(
                        children: [
                          // عالم رياضيات
                          Expanded(
                            child: _buildCuteCategoryCard(
                              context,
                              'عالم رياضيات',
                              '➕➖ تعلم بالأرقام',
                              const Color(0xFFFF8EC7), // Rose vif
                              'assets/images/math.png',
                              Icons.calculate,
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MathNiveauPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          // عالم الحيوانات
                          Expanded(
                            child: _buildCuteCategoryCard(
                              context,
                              'عالم الحيوانات',
                              '🐾 تعرف على الحيوانات',
                              const Color(0xFFFFF4A3), // Jaune clair
                              'assets/images/animal.png',
                              Icons.pets,
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AnimauxNiveauPage(),
                                  ),
                                );
                              },
                            ),
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
      ),
    );
  }

  Widget _buildCuteCategoryCard(
      BuildContext context,
      String arabicTitle,
      String subtitle,
      Color backgroundColor,
      String imagePath,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            // Fond avec motifs enfantins
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                width: 20,
                height: 20,
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
                // Zone d'image GRANDE et CENTRÉE
                Expanded(
                  flex: 3, // Plus d'espace pour l'image
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                        width: 4,
                      ),
                    ),
                    child: Center( // CENTRER l'image
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          imagePath,
                          width: 100, // PLUS GRAND
                          height: 100, // PLUS GRAND
                          fit: BoxFit.contain, // Garder les proportions
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                icon,
                                size: 50, // PLUS GRAND
                                color: _getIconColor(backgroundColor),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Zone de texte
                Expanded(
                  flex: 2, // Moins d'espace pour le texte
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Titre principal
                        Text(
                          arabicTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.1,
                            fontFamily: 'Cairo',
                            shadows: [
                              Shadow(
                                color: Colors.white,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Sous-titre avec emoji
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getTextColor(backgroundColor),
                            fontFamily: 'Cairo',
                          ),
                        ),

                        // Bouton play mignon
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'لنلعب',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.play_arrow,
                                size: 12,
                                color: Colors.pink,
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

  Widget _buildCloud() {
    return Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    if (backgroundColor == const Color(0xFFFF8EC7)) {
      return const Color(0xFFC2185B); // Rose foncé
    } else if (backgroundColor == const Color(0xFF98E4D8)) {
      return const Color(0xFF00796B); // Cyan foncé
    } else if (backgroundColor == const Color(0xFFB8E6D5)) {
      return const Color(0xFF388E3C); // Vert foncé
    } else {
      return const Color(0xFFF57C00); // Orange foncé
    }
  }

  Color _getIconColor(Color backgroundColor) {
    if (backgroundColor == const Color(0xFFFF8EC7)) {
      return const Color(0xFFE91E63); // Rose
    } else if (backgroundColor == const Color(0xFF98E4D8)) {
      return const Color(0xFF009688); // Cyan
    } else if (backgroundColor == const Color(0xFFB8E6D5)) {
      return const Color(0xFF4CAF50); // Vert
    } else {
      return const Color(0xFFFF9800); // Orange
    }
  }
}