import 'package:flutter/material.dart';
import 'missing_letter_storage_service.dart';
import './letters_page.dart';

class MissingLetterGamePage extends StatefulWidget {
  const MissingLetterGamePage({super.key});

  @override
  State<MissingLetterGamePage> createState() => _MissingLetterGamePageState();
}

class _MissingLetterGamePageState extends State<MissingLetterGamePage> {
  // Liste complète des mots avec images et lettres manquantes
  final List<Map<String, dynamic>> _allWords = [
    {
      'word': 'ت_احة',
      'fullWord': 'تفاحة',
      'missingLetter': 'ف',
      'image': 'assets/images/apple.jpg',
      'choices': ['ل', 'ف', 'ش', 'ت', 'ب'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': 'ق_م',
      'fullWord': 'قلم',
      'missingLetter': 'ل',
      'image': 'assets/images/pen.jpg',
      'choices': ['ل', 'م', 'ن', 'ه', 'ب'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 10,
    },
    {
      'word': '_تاب',
      'fullWord': 'كتاب',
      'missingLetter': 'ك',
      'image': 'assets/images/book.png',
      'choices': ['ك', 'ق', 'ب', 'ت', 'ن'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': 'س_رة',
      'fullWord': 'سيارة',
      'missingLetter': 'يا',
      'image': 'assets/images/car.jpg',
      'choices': ['يا', 'وا', 'ئ', 'ى', 'ي'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': 'ب_ت',
      'fullWord': 'بيت',
      'missingLetter': 'ي',
      'image': 'assets/images/house.jpg',
      'choices': ['ي', 'و', 'ا', 'ى', 'ت'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 3,
    },
    {
      'word': '_مس',
      'fullWord': 'شمس',
      'missingLetter': 'ش',
      'image': 'assets/images/sun.png',
      'choices': ['ش', 'س', 'ص', 'ض', 'ز'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': '_هرة',
      'fullWord': 'زهرة',
      'missingLetter': 'ز',
      'image': 'assets/images/flower.jpg',
      'choices': ['ز', 'ر', 'ذ', 'ظ', 'د'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': '_عبة',
      'fullWord': 'لعبة',
      'missingLetter': 'ل',
      'image': 'assets/images/toy.jpg',
      'choices': ['ل', 'ن', 'م', 'ه', 'ع'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': 'م_رسة',
      'fullWord': 'مدرسة',
      'missingLetter': 'د',
      'image': 'assets/images/school.jpg',
      'choices': ['د', 'ذ', 'ر', 'ز', 'ض'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': 'ق_ر',
      'fullWord': 'قمر',
      'missingLetter': 'م',
      'image': 'assets/images/moone.jpg',
      'choices': ['م', 'ن', 'ب', 'ت', 'ث'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 3,
    },
    {
      'word': 'م_كة',
      'fullWord': 'ملكة',
      'missingLetter': 'ل',
      'image': 'assets/images/queen.jpg',
      'choices': ['ل', 'ن', 'م', 'ه', 'ك'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': 'ش_رة',
      'fullWord': 'شجرة',
      'missingLetter': 'ج',
      'image': 'assets/images/tree.jpg',
      'choices': ['ج', 'ح', 'خ', 'ع', 'غ'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 5,
    },
    {
      'word': 'ح_ب',
      'fullWord': 'حلب',
      'missingLetter': 'ل',
      'image': 'assets/images/milk.jpg',
      'choices': ['ل', 'ن', 'م', 'ه', 'ك'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 4,
    }, {
      'word': 'س_عة',
      'fullWord': 'ساعة',
      'missingLetter': 'ا',
      'image': 'assets/images/clock.jpg',
      'choices': ['ا', 'أ', 'إ', 'ء', 'ؤ'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة',
      'points': 6,
    },
  ];

  List<Map<String, dynamic>> currentGameWords = [];
  int currentWordIndex = 0;
  String? selectedLetter;
  bool showResult = false;
  bool isCorrect = false;
  int score = 0;
  int streak = 0;
  int maxStreak = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      // Mélanger et sélectionner 5 mots aléatoires pour cette partie
      final shuffled = List<Map<String, dynamic>>.from(_allWords)..shuffle();
      currentGameWords = shuffled.take(5).toList();
      currentWordIndex = 0;
      selectedLetter = null;
      showResult = false;
      isCorrect = false;
      score = 0;
      streak = 0;
      maxStreak = 0;
    });
  }

  void _checkAnswer(String letter) {
    final currentWord = currentGameWords[currentWordIndex];
    final correct = letter == currentWord['missingLetter'];

    setState(() {
      selectedLetter = letter;
      showResult = true;
      isCorrect = correct;
    });

    if (correct) {
      // Calculer le score avec bonus de série
      final basePoints = currentWord['points'] as int;
      final streakBonus = streak ~/ 3; // Bonus tous les 3 mots corrects consécutifs
      final wordScore = basePoints + (streakBonus * 5);

      setState(() {
        score += wordScore;
        streak++;
        if (streak > maxStreak) {
          maxStreak = streak;
        }
      });

      // Sauvegarder les statistiques
      MissingLetterStorageService.incrementCorrectAnswers();
      MissingLetterStorageService.incrementWordsCompleted();

      // Passer au mot suivant après 2 secondes
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _nextWord();
        }
      });
    } else {
      setState(() {
        streak = 0; // Réinitialiser la série en cas d'erreur
      });
      MissingLetterStorageService.incrementWordsCompleted();
    }
  }

  void _nextWord() {
    if (currentWordIndex < currentGameWords.length - 1) {
      setState(() {
        currentWordIndex++;
        selectedLetter = null;
        showResult = false;
        isCorrect = false;
      });
    } else {
      // Fin de la partie
      _endGame();
    }
  }

  void _endGame() {
    // Sauvegarder le score final
    MissingLetterStorageService.saveScore(score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône de fin de partie
                  Icon(
                    Icons.celebration,
                    size: 80,
                    color: Colors.amber,
                  ),

                  const SizedBox(height: 20),

                  // Titre
                  const Text(
                    'إنتهت اللعبة!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Amiri',
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Sous-titre
                  const Text(
                    'لقد أكملت جميع الكلمات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontFamily: 'Amiri',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Statistiques de la partie
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildStatRow('النقاط النهائية:', '$score'),
                        _buildStatRow('أطول سلسلة:', '$maxStreak'),
                        _buildStatRow('الكلمات المكتملة:', '${currentGameWords.length}'),

                        // Meilleur score
                        FutureBuilder<int>(
                          future: MissingLetterStorageService.getHighScore(),
                          builder: (context, snapshot) {
                            final highScore = snapshot.data ?? 0;
                            final isNewRecord = score > highScore && highScore > 0;

                            return Column(
                              children: [
                                _buildStatRow('أفضل نتيجة:', '$highScore'),
                                if (isNewRecord)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'رقم قياسي جديد!',
                                          style: TextStyle(
                                            fontFamily: 'Amiri',
                                            fontSize: 12,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Boutons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Fermer la boîte de dialogue
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LettersPage(), // Aller à LettersPage
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'القائمة',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _startNewGame();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'لعبة جديدة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color _getChoiceColor(String letter) {
    if (!showResult) {
      return selectedLetter == letter
          ? Colors.lightGreen
          : Colors.lightGreen.shade200;
    }

    if (letter == currentGameWords[currentWordIndex]['missingLetter']) {
      return Colors.lightGreen;
    } else if (letter == selectedLetter && !isCorrect) {
      return Colors.red;
    }

    return Colors.lightGreen.shade200;
  }

  Color _getChoiceTextColor(String letter) {
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    if (currentGameWords.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentWord = currentGameWords[currentWordIndex];
    final progress = (currentWordIndex + 1) / currentGameWords.length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48),
              const Text(
                'الحرف المفقودة',
                style: TextStyle(
                  fontSize: 22,
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  children: [
                    // En-tête compact
                    Container(
                      padding: const EdgeInsets.all(8), // Réduire
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildHeaderItem('النقاط', '$score', Icons.stars),
                          _buildHeaderItem('السلسلة', '$streak', Icons.local_fire_department),
                          _buildHeaderItem('التقدم', '${currentWordIndex + 1}/${currentGameWords.length}', Icons.list),
                        ],
                      ),
                    ),

                    // Barre de progression
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      minHeight: 6, // Réduire
                    ),

                    const SizedBox(height: 8),

                    // Indication
                    Text(
                      currentWord['hint'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14, // Réduire
                        color: Colors.black87,
                        fontFamily: 'Amiri',
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Image plus petite
                    Container(
                      width: 140, // Réduire
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          currentWord['image'],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image,
                              size: 60, // Réduire
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Mot avec police plus petite
                    Text(
                      currentWord['word'],
                      style: const TextStyle(
                        fontSize: 48, // Réduire
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Amiri',
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Grille des choix avec moins d'espace
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: (currentWord['choices'] as List).length,
                        itemBuilder: (context, index) {
                          final letter = (currentWord['choices'] as List)[index];
                          return ElevatedButton(
                            onPressed: showResult ? null : () => _checkAnswer(letter as String),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getChoiceColor(letter as String),
                              foregroundColor: _getChoiceTextColor(letter as String),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              letter as String,
                              style: const TextStyle(
                                fontSize: 24, // Réduire
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Amiri',
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Bouton suivant
                    if (showResult && !isCorrect)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _nextWord,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  'التالي',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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

            // Boîte de résultat corrigée (première version)
            if (showResult)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: 200,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(80),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(height: 6),
                      Text(
                        isCorrect ? 'إجابة صحيحة !' : 'إجابة خاطئة !',
                        style: TextStyle(
                          fontSize: 16,
                          color: isCorrect ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Amiri',
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildHeaderItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}