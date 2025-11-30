// screens/capitale/capitale_jeu_page.dart
import 'package:flutter/material.dart';
import '../../models/pays_model.dart';

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
    List<Pays> paysMelanges = List.from(paysArabes)..shuffle();
    int startIndex = (widget.niveau - 1) * 5;
    int endIndex = startIndex + 5;

    if (endIndex > paysMelanges.length) {
      endIndex = paysMelanges.length;
    }

    List<Pays> paysSelectionnes = paysMelanges.sublist(startIndex, endIndex);

    questions = paysSelectionnes.map((pays) {
      List<String> mauvaisesReponses = [];
      List<Pays> autresPays = List.from(paysArabes)
        ..removeWhere((p) => p.nom == pays.nom);
      autresPays.shuffle();

      // MODIFICATION : Prendre seulement 2 mauvaises réponses au lieu de 3
      mauvaisesReponses = autresPays.take(2).map((p) => p.capitale).toList();
      List<String> options = [pays.capitale, ...mauvaisesReponses];
      options.shuffle();

      return {
        'pays': pays.nom,
        'capitaleCorrecte': pays.capitale,
        'options': options,
      };
    }).toList();
  }

  void _verifierReponse(String reponse) {
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

    Future.delayed(const Duration(seconds: 2), () {
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
        widget.onNiveauTermine(score);
        Navigator.pop(context);

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
                        ? const Color(0xFFFFB6C1)
                        : const Color(0xFFFFA726),
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
                      colors: [Color(0xFFFFB6C1), Color(0xFFFFFFE0)],
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
                            ? 'لقد نجحت في هذا المستوى!'
                            : 'لم تحقق النتيجة المطلوبة',
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
                            color: Color(0xFFFFB6C1),
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
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'يجب أن تحصل على 3/5 على الأقل للانتقال للمستوى التالي',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB6C1),
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
        backgroundColor: const Color(0xFFF0F8FF),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(Color(0xFFFFB6C1)),
                strokeWidth: 5,
              ),
              const SizedBox(height: 20),
              const Text(
                'جاري التحميل...',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFFB6C1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[questionActuelle];
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header compact
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFB6C1), Color(0xFFFFFFE0)],
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
                  _buildScoreCard('⭐ النقاط', '$score/${questions.length}',
                      [Color(0xFFFFB6C1), Color(0xFFFF99AA)]),
                  _buildScoreCard('📝 السؤال', '${questionActuelle + 1}/${questions.length}',
                      [Color(0xFFFFE082), Color(0xFFFFD54F)]),
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
                    color: Colors.black.withOpacity(0.1),
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
                    Color(0xFFFFB6C1),
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
                        color: couleurMessage.withOpacity(0.4),
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
                                  color: const Color(0xFFFFB6C1).withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFFFB6C1),
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
                                    color: Color(0xFF999999),
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
                                        Color(0xFFFFB6C1),
                                        Color(0xFFFFFFE0)
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

                        // Options de réponse compactes - MAINTENANT SEULEMENT 3 CHOIX
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: question['options'].map<Widget>((option) {
                            bool estCorrecte =
                                option == question['capitaleCorrecte'];
                            Color couleurBouton = const Color(0xFFFFB6C1);
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
                                    color: couleurBouton.withOpacity(0.2),
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
            color: colors.first.withOpacity(0.3),
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