import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class CountingSticksGamePage extends StatefulWidget {
  const CountingSticksGamePage({super.key});

  @override
  State<CountingSticksGamePage> createState() => _CountingSticksGamePageState();
}

class _CountingSticksGamePageState extends State<CountingSticksGamePage> {
  // Couleurs pour les bâtonnets (maximum 13 couleurs)
  final List<Color> stickColors = [
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.blue,
    Colors.amber,
    Colors.orange,
    Colors.brown,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.lime,
    Colors.cyan,
    Colors.deepOrange,
  ];

  late int correctAnswer;
  late List<int> answerOptions;
  int? selectedAnswer;
  bool showResult = false;
  bool isCorrect = false;

  // Variables de score
  int currentScore = 0;
  int highScore = 0;
  int correctAnswersCount = 0;
  int totalQuestionsCount = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadScores();
    _generateNewQuestion();
  }

  void _loadScores() {
    setState(() {
      highScore = _prefs.getInt('counting_sticks_high_score') ?? 0;
      currentScore = _prefs.getInt('counting_sticks_current_score') ?? 0;
      correctAnswersCount =
          _prefs.getInt('counting_sticks_correct_answers') ?? 0;
      totalQuestionsCount =
          _prefs.getInt('counting_sticks_total_questions') ?? 0;
    });
  }

  Future<void> _saveScores() async {
    await _prefs.setInt('counting_sticks_high_score', highScore);
    await _prefs.setInt('counting_sticks_current_score', currentScore);
    await _prefs.setInt('counting_sticks_correct_answers', correctAnswersCount);
    await _prefs.setInt('counting_sticks_total_questions', totalQuestionsCount);
  }

  Future<void> _resetScores() async {
    setState(() {
      currentScore = 0;
      correctAnswersCount = 0;
      totalQuestionsCount = 0;
    });
    await _saveScores();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم إعادة تعيين النقاط',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Amiri'),
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showStatsDialog() {
    double successRate = totalQuestionsCount > 0
        ? (correctAnswersCount / totalQuestionsCount * 100)
        : 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart, color: Colors.pink, size: 30),
                SizedBox(width: 10),
                Text(
                  'الإحصائيات',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatRow(
                    'النقاط الحالية', currentScore.toString(), Colors.blue),
                const SizedBox(height: 10),
                _buildStatRow('أعلى نقاط', highScore.toString(), Colors.green),
                const SizedBox(height: 10),
                _buildStatRow('إجابات صحيحة', correctAnswersCount.toString(),
                    Colors.purple),
                const SizedBox(height: 10),
                _buildStatRow('إجمالي الأسئلة', totalQuestionsCount.toString(),
                    Colors.orange),
                const SizedBox(height: 10),
                _buildStatRow('نسبة النجاح',
                    '${successRate.toStringAsFixed(1)}%', Colors.teal),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showResetConfirmDialog();
                },
                child: const Text(
                  'إعادة تعيين',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Amiri',
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'حسنًا',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Amiri',
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResetConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 30),
                SizedBox(width: 10),
                Text(
                  'تأكيد',
                  style: TextStyle(fontFamily: 'Amiri'),
                ),
              ],
            ),
            content: const Text(
              'هل أنت متأكد من إعادة تعيين جميع النقاط والإحصائيات؟',
              style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetScores();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'تأكيد',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Amiri',
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _generateNewQuestion() {
    setState(() {
      // Générer un nombre aléatoire entre 1 et 13
      correctAnswer = Random().nextInt(13) + 1;

      // Créer 6 options de réponse incluant la bonne réponse
      answerOptions = [correctAnswer];

      while (answerOptions.length < 6) {
        int randomNum = Random().nextInt(13) + 1;
        if (!answerOptions.contains(randomNum)) {
          answerOptions.add(randomNum);
        }
      }

      // Mélanger les options
      answerOptions.shuffle();

      selectedAnswer = null;
      showResult = false;
      isCorrect = false;
    });
  }

  void _checkAnswer(int answer) {
    setState(() {
      selectedAnswer = answer;
      showResult = true;
      isCorrect = answer == correctAnswer;
      totalQuestionsCount++;

      if (isCorrect) {
        // Ajouter 10 points pour une bonne réponse
        currentScore += 10;
        correctAnswersCount++;

        // Mettre à jour le meilleur score si nécessaire
        if (currentScore > highScore) {
          highScore = currentScore;
        }
      } else {
        // Retirer 5 points pour une mauvaise réponse (minimum 0)
        currentScore = max(0, currentScore - 5);
      }
    });

    // Sauvegarder les scores
    _saveScores();

    // Si correct, passer automatiquement à la question suivante après 2 secondes
    if (isCorrect) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _generateNewQuestion();
        }
      });
    }
  }

  Color _getAnswerButtonColor(int number) {
    if (!showResult) {
      return selectedAnswer == number
          ? Colors.pink.shade300
          : Colors.pink.shade100;
    }

    if (number == correctAnswer) {
      return Colors.green.shade300;
    } else if (number == selectedAnswer && !isCorrect) {
      return Colors.red.shade300;
    }

    return Colors.pink.shade100;
  }

  Widget _buildStick(Color color, int index) {
    // Rotation aléatoire légère pour un effet naturel
    double rotation = (Random().nextDouble() - 0.5) * 0.25;

    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 15,
        height: 150 + (Random().nextDouble() * 15 - 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              color,
              color.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerBubble(int number) {
    return GestureDetector(
      onTap: showResult ? null : () => _checkAnswer(number),
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: _getAnswerButtonColor(number),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.pink.shade400,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Amiri',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.pink.shade200,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bouton statistiques
              IconButton(
                icon:
                    const Icon(Icons.bar_chart, color: Colors.black, size: 28),
                onPressed: _showStatsDialog,
              ),
              const Text(
                'عد العصي',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Amiri',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward,
                    color: Colors.black, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Contenu principal
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Affichage des scores
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pink.shade100, Colors.pink.shade50],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildScoreDisplay(
                              'النقاط', currentScore, Icons.stars, Colors.blue),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.pink.shade200,
                          ),
                          _buildScoreDisplay('أفضل', highScore,
                              Icons.emoji_events, Colors.amber),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Titre
                    const Text(
                      'كم يوجد من قطعة؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Amiri',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Zone des bâtonnets
                    SizedBox(
                      height: 180,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(correctAnswer, (index) {
                                double horizontalPadding =
                                    correctAnswer > 8 ? 1.5 : 5.0;
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding),
                                  child: _buildStick(
                                      stickColors[index % stickColors.length],
                                      index),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Options de réponse (bulles)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: answerOptions.map((number) {
                        return _buildAnswerBubble(number);
                      }).toList(),
                    ),

                    const Spacer(),

                    // Bouton "التالي" seulement si la réponse est FAUSSE
                    if (showResult && !isCorrect)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _generateNewQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_forward, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'التالي',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Amiri',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Boîte de résultat au centre
            if (showResult)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      isCorrect
                          ? 'assets/images/success.png'
                          : 'assets/images/try_again.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          isCorrect
                              ? Icons.celebration
                              : Icons.sentiment_dissatisfied,
                          size: 80,
                          color: isCorrect ? Colors.green : Colors.orange,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCorrect ? 'إجابة صحيحة !' : 'إجابة خاطئة !',
                      style: TextStyle(
                        fontSize: 18,
                        color: isCorrect ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isCorrect ? '+10 نقاط' : '-5 نقاط',
                      style: TextStyle(
                        fontSize: 16,
                        color: isCorrect ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(
      String label, int value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontFamily: 'Amiri',
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Amiri',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
