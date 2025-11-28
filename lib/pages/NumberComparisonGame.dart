import 'package:flutter/material.dart';
import 'dart:math';

class ComparisonGamePage extends StatefulWidget {
  const ComparisonGamePage({super.key});

  @override
  State<ComparisonGamePage> createState() => _ComparisonGamePageState();
}

class _ComparisonGamePageState extends State<ComparisonGamePage> {
  late int leftNumber;
  late int rightNumber;
  String? selectedOperator;
  bool showResult = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    setState(() {
      leftNumber = Random().nextInt(20) + 1;
      rightNumber = Random().nextInt(20) + 1;
      while (leftNumber == rightNumber) {
        rightNumber = Random().nextInt(20) + 1;
      }
      selectedOperator = null;
      showResult = false;
      isCorrect = false;
    });
  }

  void _checkAnswer(String operator) {
    setState(() {
      selectedOperator = operator;
      showResult = true;

      if (operator == '<' && leftNumber < rightNumber) {
        isCorrect = true;
      } else if (operator == '=' && leftNumber == rightNumber) {
        isCorrect = true;
      } else if (operator == '>' && leftNumber > rightNumber) {
        isCorrect = true;
      } else {
        isCorrect = false;
      }
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

  Color _getButtonColor(String operator) {
    if (!showResult) {
      return selectedOperator == operator
          ? Colors.amber.shade600
          : Colors.amber.shade400;
    }

    String correctOperator =
    leftNumber < rightNumber ? '<' : (leftNumber > rightNumber ? '>' : '=');

    if (operator == correctOperator) {
      return Colors.green.shade400;
    } else if (operator == selectedOperator && !isCorrect) {
      return Colors.red.shade400;
    }

    return Colors.amber.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.amber.shade50,
        appBar: AppBar(
          backgroundColor: Colors.amber.shade300,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48),
              const Text(
                'المقارنة بين الأعداد',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Amiri',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
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
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberColumn(leftNumber),
                        Text(
                          selectedOperator ?? '−',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildNumberColumn(rightNumber),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOperatorButton('<'),
                        _buildOperatorButton('='),
                        _buildOperatorButton('>'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Bouton "التالي" seulement si la réponse est FAUSSE
                    if (showResult && !isCorrect)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _generateNewQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade400,
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
                                  fontSize: 20,
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
                      errorBuilder: (context, error, stackTrace) => Icon(
                        isCorrect ? Icons.celebration : Icons.sentiment_dissatisfied,
                        color: isCorrect ? Colors.green : Colors.orange,
                        size: 80,
                      ),
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

  Widget _buildNumberColumn(int number) {
    return Expanded(
      child: Column(
        children: [
          Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
            ),
          ),
          const SizedBox(height: 16),
          _buildFruitGrid(number),
        ],
      ),
    );
  }

  Widget _buildFruitGrid(int count) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
            (index) => const Text('🍓', style: TextStyle(fontSize: 26)),
      ),
    );
  }

  Widget _buildOperatorButton(String operator) {
    return GestureDetector(
      onTap: showResult ? null : () => _checkAnswer(operator),
      child: Container(
        width: 80,
        height: 65,
        decoration: BoxDecoration(
          color: _getButtonColor(operator),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade700, width: 2),
        ),
        child: Center(
          child: Text(
            operator,
            style: const TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}