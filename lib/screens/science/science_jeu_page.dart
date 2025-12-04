import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/science_model.dart';

class ScienceJeuPage extends StatefulWidget {
  final int niveau;
  final Function(int) onNiveauTermine;

  const ScienceJeuPage({
    super.key,
    required this.niveau,
    required this.onNiveauTermine,
  });

  @override
  State<ScienceJeuPage> createState() => _ScienceJeuPageState();
}

class _ScienceJeuPageState extends State<ScienceJeuPage> {
  int questionActuelle = 0;
  int score = 0;
  List<QuestionScience> questions = [];
  bool? reponseSelectionnee;
  String? reponseChoisie;
  String? messageFeedback;
  Color couleurMessage = Colors.green;
  bool showExplication = false;
  bool _isLoading = true;
  late Random _random;
  bool _quizTermine = false;

  @override
  void initState() {
    super.initState();
    print('=== ScienceJeuPage initState pour niveau ${widget.niveau} ===');
    // Initialiser Random avec une seed basée sur le niveau
    _random = Random(widget.niveau);
    _initialiserQuiz();
  }

  // Initialiser le quiz
  Future<void> _initialiserQuiz() async {
    print('Initialisation du quiz...');
    await _genererQuestions();
    await _chargerScoreProvisoire();
    setState(() {
      _isLoading = false;
    });
    print('Quiz initialisé avec ${questions.length} questions');
  }

  // Charger le score provisoire (pour reprendre si l'app se ferme pendant un quiz)
  Future<void> _chargerScoreProvisoire() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNiveau = prefs.getInt('science_quiz_niveau');
    final savedScore = prefs.getInt('science_quiz_score');
    final savedQuestion = prefs.getInt('science_quiz_question');

    print('Chargement score provisoire: niveau=$savedNiveau, score=$savedScore, question=$savedQuestion');
    print('Niveau actuel: ${widget.niveau}');

    // Si un quiz était en cours pour ce niveau, reprendre
    if (savedNiveau == widget.niveau && savedScore != null && savedQuestion != null) {
      // Vérifier que savedQuestion est valide
      final questionIndex = savedQuestion;
      if (questionIndex >= 0 && questionIndex < questions.length) {
        setState(() {
          score = savedScore;
          questionActuelle = questionIndex;
        });
        print('Score chargé: $score, Question: $questionActuelle');

        // Demander à l'utilisateur s'il veut reprendre
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('استمرار اللعبة'),
              content: const Text('لقد وجدنا لعبة غير مكتملة. هل تريد الاستمرار من حيث توقفت؟'),
              actions: [
                TextButton(
                  onPressed: () {
                    print('Utilisateur choisi: Démarrer nouveau');
                    Navigator.pop(context);
                    _effacerDonneesQuiz();
                  },
                  child: const Text('ابدأ من جديد'),
                ),
                TextButton(
                  onPressed: () {
                    print('Utilisateur choisi: Continuer');
                    Navigator.pop(context);
                  },
                  child: const Text('استمر'),
                ),
              ],
            ),
          );
        });
      } else {
        print('Index de question invalide, effacement des données');
        // Si l'index de la question n'est pas valide, effacer les données
        await _effacerDonneesQuiz();
      }
    } else {
      print('Aucun score provisoire trouvé pour ce niveau');
    }
  }

  // Sauvegarder le score provisoire pendant le quiz
  Future<void> _sauvegarderScoreProvisoire() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('science_quiz_niveau', widget.niveau);
      await prefs.setInt('science_quiz_score', score);
      await prefs.setInt('science_quiz_question', questionActuelle);
      print('Score sauvegardé: niveau=${widget.niveau}, score=$score, question=$questionActuelle');
    } catch (e) {
      print('Erreur lors de la sauvegarde: $e');
    }
  }

  // Effacer les données du quiz en cours
  Future<void> _effacerDonneesQuiz() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('science_quiz_niveau');
      await prefs.remove('science_quiz_score');
      await prefs.remove('science_quiz_question');

      setState(() {
        score = 0;
        questionActuelle = 0;
      });
      print('Données du quiz effacées, score réinitialisé à 0');
    } catch (e) {
      print('Erreur lors de l\'effacement: $e');
    }
  }

  Future<void> _genererQuestions() async {
    try {
      List<QuestionScience> questionsDisponibles = List.from(questionsScience);

      print('Génération des questions pour niveau ${widget.niveau}');
      print('Questions disponibles: ${questionsDisponibles.length}');

      // Mélanger avec une seed basée sur le niveau pour avoir la même séquence à chaque fois
      questionsDisponibles.shuffle(_random);

      int questionsNecessaires = 5;
      List<QuestionScience> questionsSelectionnees = [];

      if (questionsDisponibles.length >= questionsNecessaires) {
        int startIndex = ((widget.niveau - 1) * 5) % questionsDisponibles.length;
        print('Index de départ: $startIndex');

        for (int i = 0; i < questionsNecessaires; i++) {
          int index = (startIndex + i) % questionsDisponibles.length;
          questionsSelectionnees.add(questionsDisponibles[index]);
        }

        questionsSelectionnees.shuffle(_random);
      } else {
        questionsSelectionnees = List.from(questionsDisponibles);

        while (questionsSelectionnees.length < questionsNecessaires) {
          int randomIndex = (widget.niveau + questionsSelectionnees.length) % questionsDisponibles.length;
          questionsSelectionnees.add(questionsDisponibles[randomIndex]);
        }

        questionsSelectionnees = questionsSelectionnees.take(5).toList();
      }

      setState(() {
        questions = questionsSelectionnees;
      });
      print('${questions.length} questions générées');
    } catch (e) {
      print('Erreur lors de la génération des questions: $e');
      // Fournir des questions par défaut en cas d'erreur
      _fournirQuestionsParDefaut();
    }
  }

  void _fournirQuestionsParDefaut() {
    print('Utilisation des questions par défaut');
    // Questions par défaut en cas d'erreur
    setState(() {
      questions = [
        QuestionScience(
          question: 'ما هو أكبر كوكب في المجموعة الشمسية؟',
          options: ['المريخ', 'المشتري', 'الزهرة'],
          reponseCorrecte: 'المشتري',
          explication: 'المشتري هو أكبر كوكب في المجموعة الشمسية.',
        ),
        QuestionScience(
          question: 'ما هو اللون الأساسي للسماء في النهار؟',
          options: ['أحمر', 'أزرق', 'أخضر'],
          reponseCorrecte: 'أزرق',
          explication: 'السماء تظهر زرقاء بسبب تشتت الضوء في الغلاف الجوي.',
        ),
        QuestionScience(
          question: 'كم عدد أرجل العنكبوت؟',
          options: ['6', '8', '10'],
          reponseCorrecte: '8',
          explication: 'العناكب لديها 8 أرجل.',
        ),
        QuestionScience(
          question: 'ما هي أعلى قمة في العالم؟',
          options: ['كليمنجارو', 'إيفرست', 'كينابالو'],
          reponseCorrecte: 'إيفرست',
          explication: 'جبل إيفرست هو أعلى قمة في العالم.',
        ),
        QuestionScience(
          question: 'أين يعيش الدب القطبي؟',
          options: ['القارة القطبية الجنوبية', 'القارة القطبية الشمالية', 'ألاسكا'],
          reponseCorrecte: 'القارة القطبية الشمالية',
          explication: 'الدب القطبي يعيش في القارة القطبية الشمالية.',
        ),
      ];
    });
  }

  Future<void> _verifierReponse(String reponse) async {
    if (questions.isEmpty || questionActuelle >= questions.length || _quizTermine) {
      print('Vérification annulée: quiz terminé ou questions non chargées');
      return;
    }

    final bool estCorrecte = reponse == questions[questionActuelle].reponseCorrecte;
    print('Vérification réponse: $reponse, correcte: $estCorrecte');
    print('Score avant: $score');

    setState(() {
      reponseSelectionnee = true;
      reponseChoisie = reponse;
      showExplication = true;

      if (estCorrecte) {
        score++;
        messageFeedback = '🎉 أحسنت! الإجابة صحيحة 🎉';
        couleurMessage = const Color(0xFF4CAF50);
        print('Score après incrément: $score');
      } else {
        messageFeedback = '❌ الإجابة خاطئة';
        couleurMessage = const Color(0xFFFF6B6B);
        print('Score inchangé: $score');
      }
    });

    // Sauvegarder l'état actuel
    await _sauvegarderScoreProvisoire();

    Future.delayed(const Duration(seconds: 3), () {
      if (questionActuelle < questions.length - 1) {
        setState(() {
          questionActuelle++;
          reponseSelectionnee = null;
          reponseChoisie = null;
          messageFeedback = null;
          showExplication = false;
        });
        print('Question suivante: $questionActuelle');

        // Mettre à jour le score provisoire
        _sauvegarderScoreProvisoire();
      } else {
        // Quiz terminé
        print('=== QUIZ TERMINÉ ===');
        print('Score final: $score/${questions.length}');
        setState(() {
          _quizTermine = true;
        });
        _terminerQuiz();
      }
    });
  }

  Future<void> _terminerQuiz() async {
    print('=== Début terminerQuiz() ===');
    print('Score à retourner: $score');

    // NE PAS effacer les données ici - on les garde pour le parent
    // await _effacerDonneesQuiz();

    // Afficher le dialogue de résultat AVANT de retourner au parent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          print('Affichage dialogue avec score: $score');
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: Column(
              children: [
                Text(
                  score >= 3 ? '🎉' : '😊',
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
                        ? const Color(0xFF1976D2)
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
                      colors: [
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5)
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
                            color: Color(0xFF1976D2),
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
                  onPressed: () {
                    print('Bouton "حسنا" cliqué, score: $score');
                    // D'abord fermer le dialogue
                    Navigator.pop(context);
                    // Ensuite retourner le score au parent
                    widget.onNiveauTermine(score);
                    print('Score retourné au parent: $score');
                    // Finalement retourner à l'écran précédent
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
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
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (questions.isEmpty || questionActuelle >= questions.length) {
      return _buildErrorScreen();
    }

    final question = questions[questionActuelle];

    return _buildQuizScreen(question);
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF1976D2),
              ),
              strokeWidth: 5,
            ),
            const SizedBox(height: 20),
            const Text(
              'جاري تحميل الأسئلة...',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Color(0xFF1976D2),
            ),
            const SizedBox(height: 20),
            const Text(
              'حدث خطأ في تحميل الأسئلة',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'يرجى المحاولة مرة أخرى',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _initialiserQuiz();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizScreen(QuestionScience question) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec dégradé bleu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.12),
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
                    onPressed: () => _afficherAvertissementSortie(),
                  ),
                  Expanded(
                    child: Text(
                      '🔬 المستوى ${widget.niveau} 🔬',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color.fromRGBO(0, 0, 0, 0.26),
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bouton pour abandonner le quiz
                  IconButton(
                    icon: const Icon(Icons.restart_alt, color: Colors.white),
                    onPressed: () => _afficherDialogueRedemarrage(),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Score et progression - AFFICHAGE CORRIGÉ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(102, 25, 118, 210),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '⭐ ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '$score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF64B5F6),
                                Color(0xFF90CAF9)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(102, 100, 181, 246),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            '${questionActuelle + 1}/${questions.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Barre de progression
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: LinearProgressIndicator(
                          value: (questionActuelle + 1) / questions.length,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1976D2),
                          ),
                          minHeight: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Message de feedback
                    if (messageFeedback != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 20),
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
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: couleurMessage == const Color(0xFF4CAF50)
                                  ? const Color.fromARGB(102, 76, 175, 80)
                                  : const Color.fromARGB(102, 255, 107, 107),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          messageFeedback!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    // Question avec design enfantin
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(191, 25, 118, 210),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF1976D2),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.science,
                            size: 60,
                            color: Color(0xFF1976D2),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 0, 0, 0.87),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Explication scientifique (affichée après réponse)
                    if (showExplication)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F5FE),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromARGB(191, 25, 118, 210),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '💡 معلومة علمية:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              question.explication,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(0, 0, 0, 0.87),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 30),

                    // Options de réponse
                    ...question.options.map<Widget>((option) {
                      bool estCorrecte = option == question.reponseCorrecte;
                      Color couleurBouton = const Color(0xFF1976D2);
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

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: couleurBouton.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: reponseSelectionnee == null && !_quizTermine
                                ? () => _verifierReponse(option)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: couleurBouton,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (icone != null) ...[
                                  Icon(icone, size: 28),
                                  const SizedBox(width: 10),
                                ],
                                Flexible(
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    // Debug info - version corrigée
                    if (kDebugMode)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Debug: Score=$score, Question=$questionActuelle/${questions.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
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

  void _afficherAvertissementSortie() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text('إذا خرجت الآن، ستخسر تقدمك في هذا المستوى. هل تريد الاستمرار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await _effacerDonneesQuiz();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }

  void _afficherDialogueRedemarrage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة بدء المستوى'),
        content: const Text('هل تريد إعادة بدء هذا المستوى من البداية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await _effacerDonneesQuiz();
              setState(() {
                score = 0;
                questionActuelle = 0;
                reponseSelectionnee = null;
                reponseChoisie = null;
                messageFeedback = null;
                showExplication = false;
                _quizTermine = false;
              });
              Navigator.pop(context);
            },
            child: const Text('إعادة بدء'),
          ),
        ],
      ),
    );
  }
}