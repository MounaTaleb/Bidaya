// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'screens/capitale/niveau_page.dart';
import 'screens/math/math_nivrau_page.dart';
import 'screens/science/science_niveau_page.dart';
import 'screens/animaux/animaux_niveau_page.dart';

class ExercicesPage extends StatefulWidget {
  const ExercicesPage({super.key});

  @override
  State<ExercicesPage> createState() => _ExercicesPageState();
}

class _ExercicesPageState extends State<ExercicesPage>
    with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            'تعلم معنا',
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
                          '🌟 هيا نلعب ونتعلم معاً 🌟',
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

                // Grille de catégories
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Première ligne
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildModernCategoryCard(
                                  context,
                                  'عواصم الدول',
                                  '🌍 اكتشف العالم',
                                  const LinearGradient(
                                    colors: [
                                      Color(0xFF98E4D8),
                                      Color(0xFFB3F0E6)
                                    ],
                                  ),
                                  'assets/images/drapo.png',
                                  Icons.flag,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CapitaleNiveauPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildModernCategoryCard(
                                  context,
                                  'إيقاظ علمي',
                                  '🔬 استكشف العلوم',
                                  const LinearGradient(
                                    colors: [
                                      Color(0xFFB8E6D5),
                                      Color(0xFFCCF2E3)
                                    ],
                                  ),
                                  'assets/images/i9ath.png',
                                  Icons.science,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ScienceNiveauPage(),
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
                              Expanded(
                                child: _buildModernCategoryCard(
                                  context,
                                  'عالم رياضيات',
                                  '➕➖ تعلم بالأرقام',
                                  const LinearGradient(
                                    colors: [
                                      Color(0xFFFF8EC7),
                                      Color(0xFFFFAAD9)
                                    ],
                                  ),
                                  'assets/images/math.png',
                                  Icons.calculate,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MathNiveauPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildModernCategoryCard(
                                  context,
                                  'عالم الحيوانات',
                                  '🐾 تعرف على الحيوانات',
                                  const LinearGradient(
                                    colors: [
                                      Color(0xFFFFF4A3),
                                      Color(0xFFFFF9C4)
                                    ],
                                  ),
                                  'assets/images/animal.png',
                                  Icons.pets,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AnimauxNiveauPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCategoryCard(
    BuildContext context,
    String arabicTitle,
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
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              icon,
                              size: 55,
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
                          arabicTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF5C546A),
                            height: 1.2,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5C546A).withOpacity(0.7),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
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
                                'لنلعب',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF5C546A),
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.play_arrow_rounded,
                                size: 16,
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
