import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'math_jeu_page.dart';

class MathNiveauPage extends StatefulWidget {
  const MathNiveauPage({super.key});

  @override
  State<MathNiveauPage> createState() => _MathNiveauPageState();
}

class _MathNiveauPageState extends State<MathNiveauPage>
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

    // Charger les données depuis le stockage local
    _chargerDonnees();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Sauvegarder les données dans le stockage local
  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();

    // Sauvegarder les scores
    final scoresJson = scoresParNiveau.entries.map((e) => '${e.key}:${e.value}').join(';');
    await prefs.setString('math_scores', scoresJson);

    // Sauvegarder les niveaux débloqués
    final niveauxJson = niveauxDebloques.entries.where((e) => e.value).map((e) => e.key.toString()).join(';');
    await prefs.setString('math_niveaux_debloques', niveauxJson);

    // Sauvegarder le niveau actuel
    await prefs.setInt('math_niveau_actuel', niveauActuel);
  }

  // Charger les données depuis le stockage local
  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();

    // Charger les scores
    final scoresJson = prefs.getString('math_scores') ?? '';
    if (scoresJson.isNotEmpty) {
      scoresParNiveau = {};
      final scoresList = scoresJson.split(';');
      for (final score in scoresList) {
        final parts = score.split(':');
        if (parts.length == 2) {
          final niveau = int.tryParse(parts[0]);
          final scoreValue = int.tryParse(parts[1]);
          if (niveau != null && scoreValue != null) {
            scoresParNiveau[niveau] = scoreValue;
          }
        }
      }
    }

    // Charger les niveaux débloqués (par défaut seulement le niveau 1)
    niveauxDebloques = {1: true};
    final niveauxJson = prefs.getString('math_niveaux_debloques') ?? '1';
    final niveauxList = niveauxJson.split(';');
    for (final niveauStr in niveauxList) {
      final niveau = int.tryParse(niveauStr);
      if (niveau != null && niveau > 1) {
        niveauxDebloques[niveau] = true;
      }
    }

    // Charger le niveau actuel
    niveauActuel = prefs.getInt('math_niveau_actuel') ?? 1;

    // S'assurer que tous les niveaux jusqu'au niveau actuel sont débloqués
    for (int i = 1; i <= niveauActuel; i++) {
      niveauxDebloques[i] = true;
    }

    setState(() {});
  }

  // Réinitialiser toutes les données
  Future<void> _reinitialiserProgression() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة التعيين'),
        content: const Text('هل أنت متأكد أنك تريد إعادة تعيين جميع المستويات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('math_scores');
              await prefs.remove('math_niveaux_debloques');
              await prefs.remove('math_niveau_actuel');

              setState(() {
                scoresParNiveau.clear();
                niveauxDebloques = {1: true};
                niveauActuel = 1;
                for (int i = 2; i <= totalNiveaux; i++) {
                  niveauxDebloques[i] = false;
                }
              });

              Navigator.pop(context);
            },
            child: const Text('نعم'),
          ),
        ],
      ),
    );
  }

  void demarrerNiveau(int niveau) {
    if (niveauxDebloques[niveau] ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MathJeuPage(
            niveau: niveau,
            onNiveauTermine: (score) {
              _gererFinNiveau(niveau, score);
            },
          ),
        ),
      );
    }
  }

  void _gererFinNiveau(int niveau, int score) async {
    setState(() {
      scoresParNiveau[niveau] = score;

      if (score >= 3 && niveau < totalNiveaux) {
        niveauxDebloques[niveau + 1] = true;
        niveauActuel = niveau + 1;
      }
    });

    // Sauvegarder après chaque niveau terminé
    await _sauvegarderDonnees();
  }

  // Génère les positions en serpentant (gauche-droite-gauche)
  List<Offset> _genererPositionsPath(double screenWidth, double screenHeight) {
    List<Offset> positions = [];
    double verticalSpacing = 70;
    double startY = 80;

    for (int i = 0; i < totalNiveaux; i++) {
      double y = startY + (i * verticalSpacing);
      double x;

      int pattern = (i ~/ 3) % 2;
      int position = i % 3;

      if (pattern == 0) {
        if (position == 0) {
          x = screenWidth * 0.2;
        } else if (position == 1) {
          x = screenWidth * 0.5;
        } else {
          x = screenWidth * 0.8;
        }
      } else {
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

    IconData icone;
    Color couleurIcone = Colors.white;

    if (estVerrouille) {
      icone = Icons.lock;
    } else if (estComplete) {
      icone = Icons.check_circle;
    } else if (niveau % 5 == 0) {
      icone = Icons.emoji_events;
    } else {
      icone = Icons.play_arrow;
    }

    Color couleurDebut;
    Color couleurFin;

    if (estVerrouille) {
      couleurDebut = Colors.grey.shade400;
      couleurFin = Colors.grey.shade300;
    } else if (niveau % 5 == 0) {
      couleurDebut = const Color(0xFFFFD700);
      couleurFin = const Color(0xFFFFA000);
    } else if (estComplete) {
      couleurDebut = const Color(0xFF4CAF50);
      couleurFin = const Color(0xFF66BB6A);
    } else {
      couleurDebut = const Color(0xFF4CAF50);
      couleurFin = const Color(0xFF66BB6A);
    }

    return Positioned(
      top: position.dy,
      left: position.dx - 40,
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
                          : const Color(0xFF388E3C).withOpacity(0.6)),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: estVerrouille
                        ? Colors.grey.shade500
                        : (niveau % 5 == 0 ? const Color(0xFFFFA000) : const Color(0xFF4CAF50)),
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
            // Header avec dégradé vert
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
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
                      '🧮 عالم الرياضيات - 25 مستوى 🧮',
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
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'reset') {
                        _reinitialiserProgression();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'reset',
                        child: Row(
                          children: [
                            Icon(Icons.restart_alt, color: Colors.red),
                            SizedBox(width: 8),
                            Text('إعادة التعيين'),
                          ],
                        ),
                      ),
                    ],
                  ),
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

            // Zone scrollable
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
            color: Colors.green.withOpacity(0.2),
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
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}