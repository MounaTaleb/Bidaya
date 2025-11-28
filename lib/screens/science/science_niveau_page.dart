import 'package:flutter/material.dart';
import 'science_jeu_page.dart';

class ScienceNiveauPage extends StatefulWidget {
  const ScienceNiveauPage({super.key});

  @override
  State<ScienceNiveauPage> createState() => _ScienceNiveauPageState();
}

class _ScienceNiveauPageState extends State<ScienceNiveauPage>
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
          builder: (context) => ScienceJeuPage(
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
    double verticalSpacing = 70; // Espacement vertical entre les cercles (réduit)
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
    if (niveau % 5 == 0) {
      icone = Icons.emoji_events; // Trophée tous les 5 niveaux
    } else if (estComplete) {
      icone = Icons.star; // Étoile pour complété
    } else if (estVerrouille) {
      icone = Icons.lock; // Cadenas pour verrouillé
    } else {
      icone = Icons.play_arrow; // Flèche pour actif
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
                  gradient: estVerrouille
                      ? LinearGradient(
                    colors: [Colors.grey.shade400, Colors.grey.shade300],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                      : estComplete
                      ? const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                      : const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: estVerrouille
                          ? Colors.grey.withOpacity(0.4)
                          : const Color(0xFF1565C0).withOpacity(0.6),
                      blurRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: estVerrouille
                        ? Colors.grey.shade500
                        : const Color(0xFF1976D2),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icone,
                    color: Colors.white,
                    size: 38,
                  ),
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
            // Header avec dégradé bleu (adapté pour la science)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
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
                      '🔬 إيقاظ علمي 🔬',
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

            // Zone scrollable avec le chemin serpentant
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: totalNiveaux * 70 + 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF0F8FF), Color(0xFFE6F3FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Générer tous les cercles en serpentant
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
}