// screens/math_game_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';

class MathGameScreen extends StatefulWidget {
  final String gameType;
  final String title;
  final int levelNumber;

  const MathGameScreen({
    super.key,
    required this.gameType,
    required this.title,
    required this.levelNumber,
  });

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  int currentQuestion = 0;
  int score = 0;
  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
  List<int> options = [];
  bool answered = false;
  bool isCorrect = false;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    setState(() {
      answered = false;

      switch (widget.gameType) {
        case 'addition':
          num1 = random.nextInt(10) + 1;
          num2 = random.nextInt(10) + 1;
          correctAnswer = num1 + num2;
          break;
        case 'subtraction':
          num1 = random.nextInt(15) + 5;
          num2 = random.nextInt(num1);
          correctAnswer = num1 - num2;
          break;
        case 'large_numbers':
          num1 = random.nextInt(50) + 10;
          num2 = random.nextInt(50) + 10;
          correctAnswer = num1 + num2;
          break;
      }

      options = generateOptions(correctAnswer);
    });
  }

  List<int> generateOptions(int correct) {
    Set<int> opts = {correct};
    while (opts.length < 4) {
      int wrongAnswer = correct + random.nextInt(10) - 5;
      if (wrongAnswer > 0 && wrongAnswer != correct) {
        opts.add(wrongAnswer);
      }
    }
    List<int> optionsList = opts.toList();
    optionsList.shuffle();
    return optionsList;
  }

  void checkAnswer(int selected) {
    if (answered) return;

    setState(() {
      answered = true;
      isCorrect = selected == correctAnswer;
      if (isCorrect) {
        score += 10;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (currentQuestion < 9) {
        setState(() {
          currentQuestion++;
        });
        generateQuestion();
      } else {
        showResultDialog();
      }
    });
  }

  void showResultDialog() {
    // Calculer les étoiles gagnées
    int starsEarned = 0;
    if (score >= 90) {
      starsEarned = 3;
    } else if (score >= 70) {
      starsEarned = 2;
    } else if (score >= 50) {
      starsEarned = 1;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'انتهت اللعبة!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Afficher les étoiles gagnées
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  Icons.star,
                  color: index < starsEarned ? Colors.amber : Colors.grey,
                  size: 40,
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              'نقاطك: $score/100',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              score >= 70 ? 'ممتاز! 🎉' : 'حاول مرة أخرى! 💪',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'العودة',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Sauvegarder la progression (à implémenter plus tard)
              if (score >= 50) {
                // await ProgressService.updateLevelProgress(
                //   'math',
                //   widget.levelNumber,
                //   starsEarned,
                // );
              }

              Navigator.pop(context);
              setState(() {
                currentQuestion = 0;
                score = 0;
              });
              generateQuestion();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'إعادة اللعب',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  String getOperationSymbol() {
    switch (widget.gameType) {
      case 'addition':
      case 'large_numbers':
        return '+';
      case 'subtraction':
        return '-';
      default:
        return '+';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.purple.shade200],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'النقاط: $score',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: (currentQuestion + 1) / 10,
                  backgroundColor: Colors.white.withAlpha(80),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'السؤال ${currentQuestion + 1} من 10',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'احسب الناتج',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$num1',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          getOperationSymbol(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '$num2',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          '=',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          '?',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return AnswerButton(
                      answer: options[index],
                      isCorrect: options[index] == correctAnswer,
                      answered: answered,
                      onTap: () => checkAnswer(options[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final int answer;
  final bool isCorrect;
  final bool answered;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.answer,
    required this.isCorrect,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;

    if (answered) {
      if (isCorrect) {
        color = Colors.green;
      }
    }

    return InkWell(
      onTap: answered ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: answered && isCorrect ? Colors.green : Colors.purple.shade200,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$answer',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: answered && isCorrect ? Colors.white : Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}