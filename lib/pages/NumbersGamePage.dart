import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
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
    });

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
      return selectedAnswer == number ? Colors.pink.shade300 : Colors.pink.shade100;
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
        width: 18,
        height: 180 + (Random().nextDouble() * 20 - 10),
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
        width: 75,
        height: 75,
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
              fontSize: 28,
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
              const SizedBox(width: 48),
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
                icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 28),
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
                    const SizedBox(height: 13),

                    // Titre
                    const Text(
                      'كم يوجد من قطعة؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Amiri',
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Zone des bâtonnets
                    SizedBox(
                      height: 220,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(correctAnswer, (index) {
                                double horizontalPadding = correctAnswer > 8 ? 1.5 : 5.0;
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                                  child: _buildStick(stickColors[index % stickColors.length], index),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Options de réponse (bulles)
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
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
                width: 250,
                height: 230,
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
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          isCorrect ? Icons.celebration : Icons.sentiment_dissatisfied,
                          size: 80,
                          color: isCorrect ? Colors.green : Colors.orange,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isCorrect ? 'إجابة صحيحة !' : 'إجابة خاطئة !',
                      style: TextStyle(
                        fontSize: 22,
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
}