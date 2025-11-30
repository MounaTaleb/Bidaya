import 'package:flutter/material.dart';
import 'animaux_jeu_page.dart';

class AnimauxNiveauPage extends StatefulWidget {
  const AnimauxNiveauPage({super.key});

  @override
  State<AnimauxNiveauPage> createState() => _AnimauxNiveauPageState();
}

class _AnimauxNiveauPageState extends State<AnimauxNiveauPage>
    with SingleTickerProviderStateMixin {
  int niveauActuel = 1;
  final int totalNiveaux = 25;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  Map<int, int> scoresParNiveau = {};
  Map<int, bool> niveauxDebloques = {1: true};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut,
      ),
    );
    _animationController.repeat(reverse: true);

    for (int i = 2; i <= totalNiveaux; i++) {
      niveauxDebloques[i] = false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void demarrerNiveau(int niveau) {
    if (niveauxDebloques[niveau] ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimauxJeuPage(
            niveau: niveau,
            onNiveauTermine: (score) {
              _gererFinNiveau(niveau, score);
            },
          ),
        ),
      );
    }
  }

  void _gererFinNiveau(int niveau, int score) {
    setState(() {
      scoresParNiveau[niveau] = score;

      if (score >= 3 && niveau < totalNiveaux) {
        niveauxDebloques[niveau + 1] = true;
        niveauActuel = niveau + 1;
      }
    });
  }

  // Génère les positions en serpentant (gauche-droite-gauche)
  List<Offset> _genererPositionsPath(double screenWidth, double screenHeight) {
    List<Offset> positions = [];
    double verticalSpacing = 70; // Espacement vertical entre les cercles
    double startY = 80; // Position Y de départ

    for (int i = 0; i < totalNiveaux; i++) {
      double y = startY + (i * verticalSpacing);
      double x;

      // Créer un effet de serpent : gauche-centre-droite-centre
      int pattern = (i ~/ 3) % 2; // Change de direction tous les 3 niveaux
      int position = i % 3;

      if (pattern == 0) {
        // Gauche -> Centre -> Droite
        if (position == 0) {
          x = screenWidth * 0.2;
        } else if (position == 1) {
          x = screenWidth * 0.5;
        } else {
          x = screenWidth * 0.8;
        }
      } else {
        // Droite -> Centre -> Gauche
        if (position == 0) {
          x = screenWidth * 0.8;
        } else if (position == 1) {
          x = screenWidth * 0.5;
        } else {
          x = screenWidth * 0.2;
        }
      }

      positions.add(Offset(x, y));
    }

    return positions;
  }

  Widget _buildCircleNiveau(int niveau, Offset position) {
    final bool estComplete = scoresParNiveau.containsKey(niveau) && scoresParNiveau[niveau]! >= 3;
    final bool estVerrouille = !(niveauxDebloques[niveau] ?? false);
    final bool estActif = !estVerrouille && !estComplete;

    // Icônes variées selon le niveau
    IconData icone;
    Color couleurIcone = Colors.white;

    if (estVerrouille) {
      icone = Icons.lock;
    } else if (estComplete) {
      icone = Icons.check_circle;
    } else if (niveau % 5 == 0) {
      icone = Icons.emoji_events; // Trophée tous les 5 niveaux
    } else {
      icone = Icons.play_arrow;
    }

    // Couleurs spéciales pour les niveaux multiples de 5
    Color couleurDebut;
    Color couleurFin;

    if (estVerrouille) {
      couleurDebut = Colors.grey.shade400;
      couleurFin = Colors.grey.shade300;
    } else if (niveau % 5 == 0) {
      // Niveaux spéciaux (5, 10, 15, 20, 25) en doré
      couleurDebut = const Color(0xFFFFD700);
      couleurFin = const Color(0xFFFFA000);
    } else if (estComplete) {
      couleurDebut = const Color(0xFF795548);
      couleurFin = const Color(0xFFA1887F);
    } else {
      couleurDebut = const Color(0xFF795548);
      couleurFin = const Color(0xFFA1887F);
    }

    return Positioned(
      top: position.dy,
      left: position.dx - 40, // Centre le cercle (80/2)
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, estActif ? _bounceAnimation.value : 0),
            child: GestureDetector(
              onTap: () => demarrerNiveau(niveau),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [couleurDebut, couleurFin],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: estVerrouille
                          ? Colors.grey.withOpacity(0.4)
                          : (niveau % 5 == 0
                          ? const Color(0xFFFFA000).withOpacity(0.6)
                          : const Color(0xFF5D4037).withOpacity(0.6)),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: estVerrouille
                        ? Colors.grey.shade500
                        : (niveau % 5 == 0 ? const Color(0xFFFFA000) : const Color(0xFF795548)),
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icone,
                      color: couleurIcone,
                      size: niveau % 5 == 0 ? 32 : 30,
                    ),
                    if (!estVerrouille)
                      Text(
                        '$niveau',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final positions = _genererPositionsPath(screenWidth, screenHeight);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec dégradé marron (adapté pour les animaux)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF795548), Color(0xFFA1887F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        size: 24, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      '🐾 عالم الحيوانات - 25 مستوى 🐾',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Indicateur de progression
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressIndicator('المستوى الحالي', '$niveauActuel/$totalNiveaux'),
                  _buildProgressIndicator('المستويات المكتملة', '${scoresParNiveau.length}/$totalNiveaux'),
                ],
              ),
            ),

            // Zone scrollable sans les lignes de chemin
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: totalNiveaux * 70 + 200, // Hauteur adaptée pour 25 niveaux
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF0F8FF), Color(0xFFE6F3FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Générer tous les cercles en serpentant (sans lignes)
                      ...List.generate(
                        totalNiveaux,
                            (index) => _buildCircleNiveau(index + 1, positions[index]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF795548),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF795548),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}