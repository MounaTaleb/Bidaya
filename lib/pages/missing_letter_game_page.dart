import 'package:flutter/material.dart';

class MissingLetterGamePage extends StatefulWidget {
  const MissingLetterGamePage({super.key});

  @override
  State<MissingLetterGamePage> createState() => _MissingLetterGamePageState();
}

class _MissingLetterGamePageState extends State<MissingLetterGamePage> {
  // Liste des mots avec images et lettres manquantes
  final List<Map<String, dynamic>> words = [
    {
      'word': 'ت_حة',
      'fullWord': 'تفاحة',
      'missingLetter': 'فا',
      'image': 'assets/images/apple.jpg',
      'choices': ['ل', 'فا', 'ش', 'ت', 'ب'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة'
    },
    {
      'word': 'ق_م',
      'fullWord': 'قلم',
      'missingLetter': 'ل',
      'image': 'assets/images/pen.jpg',
      'choices': ['ل', 'م', 'ن', 'ه', 'ب'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة'
    },
    {
      'word': '_تاب',
      'fullWord': 'كتاب',
      'missingLetter': 'ك',
      'image': 'assets/images/book.png',
      'choices': ['ك', 'ق', 'ب', 'ت', 'ن'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة'
    },
    {
      'word': 'س_رة',
      'fullWord': 'سيارة',
      'missingLetter': 'يا',
      'image': 'assets/images/car.jpg',
      'choices': ['يا', 'وا', 'ئ', 'ى', 'ي'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة'
    },
    {
      'word': 'ب_ت',
      'fullWord': 'بيت',
      'missingLetter': 'ي',
      'image': 'assets/images/house.jpg',
      'choices': ['ي', 'و', 'ا', 'ى', 'ت'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة'
    },
    {
      'word': '_مس',
      'fullWord': 'شمس',
      'missingLetter': 'ش',
      'image': 'assets/images/sun.png',
      'choices': ['ش', 'س', 'ص', 'ض', 'ز'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة'
    },
    {
      'word': '_هرة',
      'fullWord': 'زهرة',
      'missingLetter': 'ز',
      'image': 'assets/images/flower.jpg',
      'choices': ['ز', 'ر', 'ذ', 'ظ', 'د'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة'
    },
    {
      'word': '_عبة',
      'fullWord': 'لعبة',
      'missingLetter': 'ل',
      'image': 'assets/images/toy.jpg',
      'choices': ['ل', 'ن', 'م', 'ه', 'ع'],
      'hint': 'اختر الحرف المناسب لإكمال الكلمة'
    },
  ];

  int currentWordIndex = 0;
  String? selectedLetter;
  bool showResult = false;
  bool isCorrect = false;

  void _checkAnswer(String letter) {
    setState(() {
      selectedLetter = letter;
      showResult = true;
      isCorrect = letter == words[currentWordIndex]['missingLetter'];
    });

    // Si correct, passer automatiquement au mot suivant après 2 secondes
    if (isCorrect) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _nextWord();
        }
      });
    }
  }

  void _nextWord() {
    setState(() {
      currentWordIndex = (currentWordIndex + 1) % words.length;
      selectedLetter = null;
      showResult = false;
      isCorrect = false;
    });
  }

  Color _getChoiceColor(String letter) {
    if (!showResult) {
      return selectedLetter == letter
          ? Colors.lightGreen
          : Colors.lightGreen.shade200;
    }

    if (letter == words[currentWordIndex]['missingLetter']) {
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
    final currentWord = words[currentWordIndex];

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
            // Contenu principal
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    Text(
                      currentWord['hint'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontFamily: 'Amiri',
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Image
                    Container(
                      width: 180,
                      height: 180,
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
                              size: 80,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      currentWord['word'],
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Amiri',
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Choix de lettres
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: currentWord['choices'].length,
                        itemBuilder: (context, index) {
                          final letter = currentWord['choices'][index];
                          return ElevatedButton(
                            onPressed: showResult ? null : () => _checkAnswer(letter),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getChoiceColor(letter),
                              foregroundColor: _getChoiceTextColor(letter),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Amiri',
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bouton "التالي" seulement si la réponse est FAUSSE
                    if (showResult && !isCorrect)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nextWord,
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