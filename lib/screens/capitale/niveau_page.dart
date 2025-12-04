// screens/capitale/niveau_page.dart
import 'package:flutter/material.dart';
import 'capitale_jeu_page.dart.dart';
import '../../models/pays_model.dart';
import '../../services/local_storage_service.dart'; // AJOUT: Import du service

class CapitaleNiveauPage extends StatefulWidget {
  const CapitaleNiveauPage({super.key});

  @override
  State<CapitaleNiveauPage> createState() => _CapitaleNiveauPageState();
}

class _CapitaleNiveauPageState extends State<CapitaleNiveauPage>
    with SingleTickerProviderStateMixin {
  int niveauActuel = 1;
  final int totalNiveaux = 25;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  Map<int, int> scoresParNiveau = {};
  Map<int, bool> niveauxDebloques = {1: true};

  // AJOUT: Instance du service de stockage
  final LocalStorageService _storageService = LocalStorageService();
  bool _isLoading = true;

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

    // AJOUT: Charger la progression au démarrage
    _loadProgress();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // AJOUT: Charger la progression depuis le stockage local
  Future<void> _loadProgress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer le dernier niveau débloqué
      final dernierNiveau = await _storageService.getLastLevel('capitale');

      // Initialiser les niveaux débloqués
      for (int i = 1; i <= totalNiveaux; i++) {
        niveauxDebloques[i] = i <= dernierNiveau;
      }

      // Récupérer les scores et niveaux terminés
      for (int i = 1; i <= totalNiveaux; i++) {
        final score = await _storageService.getBestScore('capitale', i);
        if (score > 0) {
          scoresParNiveau[i] = score;
        }

        // Si le niveau est terminé, débloquer le suivant
        final estTermine = await _storageService.isLevelCompleted('capitale', i);
        if (estTermine && i < totalNiveaux) {
          niveauxDebloques[i + 1] = true;
        }
      }

      // Mettre à jour le niveau actuel
      niveauActuel = dernierNiveau;

    } catch (e) {
      print('❌ Erreur lors du chargement de la progression: $e');
      // Valeurs par défaut
      for (int i = 2; i <= totalNiveaux; i++) {
        niveauxDebloques[i] = false;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // AJOUT: Sauvegarder la progression
  Future<void> _saveProgress() async {
    try {
      // Sauvegarder tous les niveaux terminés
      for (int niveau in scoresParNiveau.keys) {
        if (scoresParNiveau[niveau]! >= 3) {
          await _storageService.saveProgress(
            category: 'capitale',
            niveau: niveau,
            score: scoresParNiveau[niveau]!,
            niveauTermine: true,
          );
        }
      }

      // Sauvegarder le dernier niveau débloqué
      if (niveauActuel > 1) {
        await _storageService.saveProgress(
          category: 'capitale',
          niveau: niveauActuel,
          score: scoresParNiveau[niveauActuel] ?? 0,
          niveauTermine: false,
        );
      }

      print('✅ Progression sauvegardée pour les capitales');
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde: $e');
    }
  }

  void demarrerNiveau(int niveau) {
    if (niveauxDebloques[niveau] ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CapitaleJeuPage(
            niveau: niveau,
            onNiveauTermine: (score) async {
              await _gererFinNiveau(niveau, score);
            },
          ),
        ),
      );
    }
  }

  Future<void> _gererFinNiveau(int niveau, int score) async {
    setState(() {
      scoresParNiveau[niveau] = score;

      if (score >= 3 && niveau < totalNiveaux) {
        niveauxDebloques[niveau + 1] = true;
        if (niveau + 1 > niveauActuel) {
          niveauActuel = niveau + 1;
        }
      }
    });

    // AJOUT: Sauvegarder la progression après chaque niveau
    await _saveProgress();
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
      couleurDebut = const Color.fromARGB(255, 255, 182, 193); // CORRIGÉ: Color(0xFFFFB6C1)
      couleurFin = const Color.fromARGB(255, 255, 153, 170);  // CORRIGÉ: Color(0xFFFF99AA)
    } else {
      couleurDebut = const Color.fromARGB(255, 255, 182, 193); // CORRIGÉ: Color(0xFFFFB6C1)
      couleurFin = const Color.fromARGB(255, 255, 153, 170);  // CORRIGÉ: Color(0xFFFF99AA)
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
                          : const Color.fromARGB(255, 255, 143, 163).withOpacity(0.6)), // CORRIGÉ
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: estVerrouille
                        ? Colors.grey.shade500
                        : (niveau % 5 == 0 ? const Color(0xFFFFA000) : const Color.fromARGB(255, 255, 153, 170)), // CORRIGÉ
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
                    if (scoresParNiveau.containsKey(niveau))
                      Text(
                        '${scoresParNiveau[niveau]}/5',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 248, 255), // Color(0xFFF0F8FF)
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 255, 182, 193), // Color(0xFFFFB6C1)
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'جاري تحميل المستويات...',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 182, 193), // Color(0xFFFFB6C1)
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final positions = _genererPositionsPath(screenWidth, screenHeight);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 248, 255), // Color(0xFFF0F8FF)
      body: SafeArea(
        child: Column(
          children: [
            // Header avec dégradé rose et jaune
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                    Color.fromARGB(255, 255, 255, 224)  // CORRIGÉ: Color(0xFFFFFFE0)
                  ],
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
                      '🏛️ عواصم الدول - 25 مستوى 🏛️',
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

            // Légende des couleurs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color.fromARGB(255, 255, 182, 193).withOpacity(0.3)), // CORRIGÉ
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(const Color.fromARGB(255, 255, 182, 193), 'مفتوح'), // CORRIGÉ
                  _buildLegendItem(Colors.grey, 'مقفل'),
                  _buildLegendItem(const Color(0xFFFFD700), 'خاص'),
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
                      colors: [
                        Color.fromARGB(255, 240, 248, 255), // CORRIGÉ: Color(0xFFF0F8FF)
                        Color.fromARGB(255, 230, 243, 255)  // CORRIGÉ: Color(0xFFE6F3FF)
                      ],
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
            color: const Color.fromARGB(255, 255, 182, 193).withOpacity(0.2), // CORRIGÉ
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
              color: Color.fromARGB(255, 255, 182, 193), // CORRIGÉ
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 255, 182, 193), // CORRIGÉ
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // AJOUT: Méthode pour créer un élément de légende
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 255, 182, 193), // CORRIGÉ
          ),
        ),
      ],
    );
  }
}