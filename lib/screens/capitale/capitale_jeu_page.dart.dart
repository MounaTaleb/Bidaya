// screens/capitale/capitale_jeu_page.dart
import 'package:flutter/material.dart';
import '../../models/pays_model.dart';
import '../../services/local_storage_service.dart'; // AJOUT: Import du service

class CapitaleJeuPage extends StatefulWidget {
  final int niveau;
  final Function(int) onNiveauTermine;

  const CapitaleJeuPage({
    super.key,
    required this.niveau,
    required this.onNiveauTermine,
  });

  @override
  State<CapitaleJeuPage> createState() => _CapitaleJeuPageState();
}

class _CapitaleJeuPageState extends State<CapitaleJeuPage>
    with SingleTickerProviderStateMixin {
  int questionActuelle = 0;
  int score = 0;
  List<Map<String, dynamic>> questions = [];
  bool? reponseSelectionnee;
  String? reponseChoisie;
  String? messageFeedback;
  Color couleurMessage = Colors.green;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // AJOUT: Instance du service de stockage
  final LocalStorageService _storageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _genererQuestions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _genererQuestions() {
    // Créer une copie de la liste des pays
    List<Pays> paysDisponibles = List.from(paysArabes);

    // Mélanger la liste pour plus de variété
    paysDisponibles.shuffle();

    // Calculer le nombre de questions nécessaires (5 par niveau)
    int questionsNecessaires = 5;

    // Pour les niveaux élevés, nous allons répéter les pays si nécessaire
    List<Pays> paysSelectionnes = [];

    if (paysDisponibles.length >= questionsNecessaires) {
      // Si nous avons assez de pays, prendre des pays aléatoires
      int startIndex = ((widget.niveau - 1) * 5) % paysDisponibles.length;

      for (int i = 0; i < questionsNecessaires; i++) {
        int index = (startIndex + i) % paysDisponibles.length;
        paysSelectionnes.add(paysDisponibles[index]);
      }

      // Mélanger les pays sélectionnés pour éviter l'ordre séquentiel
      paysSelectionnes.shuffle();
    } else {
      // Si nous n'avons pas assez de pays, utiliser tous les pays
      // et compléter avec des répétitions aléatoires
      paysSelectionnes = List.from(paysDisponibles);

      while (paysSelectionnes.length < questionsNecessaires) {
        int randomIndex = (widget.niveau + paysSelectionnes.length) % paysDisponibles.length;
        paysSelectionnes.add(paysDisponibles[randomIndex]);
      }

      // Prendre seulement les 5 premiers
      paysSelectionnes = paysSelectionnes.take(5).toList();
    }

    // Générer les questions
    questions = paysSelectionnes.map((pays) {
      // Créer une liste de toutes les capitales sauf la bonne
      List<String> toutesCapitales = paysArabes.map((p) => p.capitale).toList();
      toutesCapitales.remove(pays.capitale);

      // Mélanger et prendre 2 mauvaises réponses
      toutesCapitales.shuffle();
      List<String> mauvaisesReponses = toutesCapitales.take(2).toList();

      // Créer les options
      List<String> options = [pays.capitale, ...mauvaisesReponses];
      options.shuffle();

      return {
        'pays': pays.nom,
        'capitaleCorrecte': pays.capitale,
        'options': options,
      };
    }).toList();
  }

  // AJOUT: Fonction pour sauvegarder la progression
  Future<void> _saveProgress() async {
    try {
      await _storageService.saveProgress(
        category: 'capitale', // Catégorie pour les capitales
        niveau: widget.niveau,
        score: score,
        niveauTermine: score >= 3,
      );
      print('✅ Progression sauvegardée pour le niveau ${widget.niveau} (capitale)');
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde: $e');
    }
  }

  void _verifierReponse(String reponse) async { // AJOUT: async
    final bool estCorrecte =
        reponse == questions[questionActuelle]['capitaleCorrecte'];

    setState(() {
      reponseSelectionnee = true;
      reponseChoisie = reponse;

      if (estCorrecte) {
        score++;
        messageFeedback = '🎉 أحسنت! الإجابة صحيحة 🎉';
        couleurMessage = const Color(0xFF4CAF50);
      } else {
        messageFeedback =
        '❌ الإجابة خاطئة. العاصمة الصحيحة هي: ${questions[questionActuelle]['capitaleCorrecte']}';
        couleurMessage = const Color(0xFFFF6B6B);
      }
    });

    Future.delayed(const Duration(seconds: 2), () async { // AJOUT: async
      if (questionActuelle < questions.length - 1) {
        setState(() {
          questionActuelle++;
          reponseSelectionnee = null;
          reponseChoisie = null;
          messageFeedback = null;
        });
        _animationController.reset();
        _animationController.forward();
      } else {
        // AJOUT: Sauvegarder la progression avant d'afficher le dialogue
        await _saveProgress();

        widget.onNiveauTermine(score);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: Column(
              children: [
                Text(
                  score >= 3 ? '🌟' : '😊',
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 10),
                Text(
                  score >= 3 ? 'تهانينا!' : 'حاول مرة أخرى',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: score >= 3
                        ? const Color.fromARGB(255, 255, 182, 193) // CORRIGÉ: Color(0xFFFFB6C1)
                        : const Color.fromARGB(255, 255, 167, 38), // CORRIGÉ: Color(0xFFFFA726)
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                        Color.fromARGB(255, 255, 255, 224)  // CORRIGÉ: Color(0xFFFFFFE0)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        score >= 3
                            ? 'لقد نجحت في المستوى ${widget.niveau}!'
                            : 'لم تحقق النتيجة المطلوبة في المستوى ${widget.niveau}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'النتيجة: $score/${questions.length} ⭐',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (score < 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 249, 230), // CORRIGÉ: Color(0xFFFFF9E6)
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'يجب أن تحصل على 3/5 على الأقل للانتقال للمستوى التالي',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 102, 102, 102), // CORRIGÉ: Color(0xFF666666)
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fermer la boîte de dialogue
                    Navigator.pop(context); // Retourner à l'écran précédent
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    elevation: 5,
                  ),
                  child: const Text(
                    'حسنا 👍',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 248, 255), // CORRIGÉ: Color(0xFFF0F8FF)
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 255, 182, 193)), // CORRIGÉ: Color(0xFFFFB6C1)
                strokeWidth: 5,
              ),
              const SizedBox(height: 20),
              Text(
                'جاري تحميل المستوى ${widget.niveau}...',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[questionActuelle];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 248, 255), // CORRIGÉ: Color(0xFFF0F8FF)
      body: SafeArea(
        child: Column(
          children: [
            // Header compact
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                        size: 22, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      '🏛️ المستوى ${widget.niveau}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
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

            // Score et progression compact
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreCard('⭐ النقاط', '$score/${questions.length}', [
                    const Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                    const Color.fromARGB(255, 255, 153, 170)  // CORRIGÉ: Color(0xFFFF99AA)
                  ]),
                  _buildScoreCard('📝 السؤال', '${questionActuelle + 1}/${questions.length}', [
                    const Color.fromARGB(255, 255, 224, 130), // CORRIGÉ: Color(0xFFFFE082)
                    const Color.fromARGB(255, 255, 213, 79)   // CORRIGÉ: Color(0xFFFFD54F)
                  ]),
                ],
              ),
            ),

            // Barre de progression fine
            Container(
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25), // CORRIGÉ: .withOpacity(0.1)
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (questionActuelle + 1) / questions.length,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                  ),
                  minHeight: 8,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Message de feedback compact
            if (messageFeedback != null)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: couleurMessage == const Color(0xFF4CAF50)
                          ? [
                        const Color(0xFF4CAF50),
                        const Color(0xFF66BB6A)
                      ]
                          : [
                        const Color(0xFFFF6B6B),
                        const Color(0xFFFF8787)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: couleurMessage == const Color(0xFF4CAF50)
                            ? const Color(0xFF4CAF50).withAlpha(100) // CORRIGÉ
                            : const Color(0xFFFF6B6B).withAlpha(100), // CORRIGÉ
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    messageFeedback!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

            // Contenu principal adaptatif
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Question compacte
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 255, 182, 193).withAlpha(50), // CORRIGÉ
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '🌍',
                                  style: TextStyle(fontSize: 40),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'ما هي عاصمة',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 153, 153, 153), // CORRIGÉ: Color(0xFF999999)
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 182, 193), // CORRIGÉ: Color(0xFFFFB6C1)
                                        Color.fromARGB(255, 255, 255, 224)  // CORRIGÉ: Color(0xFFFFFFE0)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    question['pays'],
                                    style: const TextStyle(
                                      fontSize: 24,
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
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Options de réponse compactes - 3 CHOIX
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: question['options'].map<Widget>((option) {
                            bool estCorrecte =
                                option == question['capitaleCorrecte'];
                            Color couleurBouton = const Color.fromARGB(255, 255, 182, 193); // CORRIGÉ: Color(0xFFFFB6C1)
                            IconData? icone;

                            if (reponseSelectionnee != null) {
                              if (estCorrecte) {
                                couleurBouton = const Color(0xFF4CAF50);
                                icone = Icons.check_circle;
                              } else if (option == reponseChoisie) {
                                couleurBouton = const Color(0xFFFF6B6B);
                                icone = Icons.cancel;
                              } else {
                                couleurBouton = Colors.grey.shade300;
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: couleurBouton.withAlpha(50), // CORRIGÉ
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: reponseSelectionnee == null
                                    ? () => _verifierReponse(option)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: couleurBouton,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, constraints.maxHeight * 0.1),
                                  maximumSize: Size(double.infinity, constraints.maxHeight * 0.15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (icone != null) ...[
                                      Icon(icone, size: 20),
                                      const SizedBox(width: 6),
                                    ],
                                    Flexible(
                                      child: Text(
                                        option,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String title, String value, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.first.withAlpha(75), // CORRIGÉ
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}