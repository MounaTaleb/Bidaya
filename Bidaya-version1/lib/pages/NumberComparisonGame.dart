import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ComparisonGamePage extends StatefulWidget {
  const ComparisonGamePage({super.key});

  @override
  State<ComparisonGamePage> createState() => _ComparisonGamePageState();
}

class _ComparisonGamePageState extends State<ComparisonGamePage> {
  // Initialisation avec des valeurs par défaut
  int leftNumber = 0;
  int rightNumber = 0;
  String? selectedOperator;
  bool showResult = false;
  bool isCorrect = false;

  // Liste des emojis de fruits
  final List<String> fruits = [
    '🍓',
    '🍎',
    '🍊',
    '🍋',
    '🍌',
    '🍉',
    '🍇',
    '🍑',
    '🥝',
    '🍒',
    '🍍',
    '🥭',
    '🍏'
  ];
  String currentFruit = '🍓';

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
    _generateNewQuestion(); // Assure que leftNumber et rightNumber sont initialisés
  }

  void _loadScores() {
    setState(() {
      highScore = _prefs.getInt('comparison_high_score') ?? 0;
      currentScore = _prefs.getInt('comparison_current_score') ?? 0;
      correctAnswersCount = _prefs.getInt('comparison_correct_answers') ?? 0;
      totalQuestionsCount = _prefs.getInt('comparison_total_questions') ?? 0;
    });
  }

  Future<void> _saveScores() async {
    await _prefs.setInt('comparison_high_score', highScore);
    await _prefs.setInt('comparison_current_score', currentScore);
    await _prefs.setInt('comparison_correct_answers', correctAnswersCount);
    await _prefs.setInt('comparison_total_questions', totalQuestionsCount);
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
                Icon(Icons.bar_chart, color: Colors.amber, size: 30),
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
                  backgroundColor: Colors.amber,
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
      totalQuestionsCount++;

      if (operator == '<' && leftNumber < rightNumber) {
        isCorrect = true;
      } else if (operator == '=' && leftNumber == rightNumber) {
        isCorrect = true;
      } else if (operator == '>' && leftNumber > rightNumber) {
        isCorrect = true;
      } else {
        isCorrect = false;
      }

      if (isCorrect) {
        currentScore += 10;
        correctAnswersCount++;
        if (currentScore > highScore) highScore = currentScore;
      } else {
        currentScore = max(0, currentScore - 5);
      }
    });

    _saveScores();

    if (isCorrect) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _generateNewQuestion();
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
              IconButton(
                icon:
                    const Icon(Icons.bar_chart, color: Colors.black, size: 28),
                onPressed: _showStatsDialog,
              ),
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade100, Colors.amber.shade50],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.2),
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
                            height: 25,
                            color: Colors.amber.shade300,
                          ),
                          _buildScoreDisplay('أفضل', highScore,
                              Icons.emoji_events, Colors.orange),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNumberColumn(leftNumber),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              selectedOperator ?? '−',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildNumberColumn(rightNumber),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOperatorButton('<'),
                        _buildOperatorButton('='),
                        _buildOperatorButton('>'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (showResult && !isCorrect)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _generateNewQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                      ),
                  ],
                ),
              ),
            ),
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
                      errorBuilder: (context, error, stackTrace) => Icon(
                        isCorrect
                            ? Icons.celebration
                            : Icons.sentiment_dissatisfied,
                        color: isCorrect ? Colors.green : Colors.orange,
                        size: 80,
                      ),
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

  Widget _buildNumberColumn(int number) {
    return Expanded(
      child: Column(
        children: [
          Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: SingleChildScrollView(
              child: _buildFruitGrid(number),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFruitGrid(int count) {
    double fruitSize = count > 15 ? 20 : (count > 10 ? 22 : 24);

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (index) => Text('🍓', style: TextStyle(fontSize: fruitSize)),
      ),
    );
  }

  Widget _buildOperatorButton(String operator) {
    return GestureDetector(
      onTap: showResult ? null : () => _checkAnswer(operator),
      child: Container(
        width: 70,
        height: 60,
        decoration: BoxDecoration(
          color: _getButtonColor(operator),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade700, width: 2),
        ),
        child: Center(
          child: Text(
            operator,
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(
      String label, int value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                fontFamily: 'Amiri',
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
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
