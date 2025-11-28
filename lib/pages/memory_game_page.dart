import 'package:flutter/material.dart';
import 'dart:math';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> with SingleTickerProviderStateMixin {
  int? selectedLevel;
  bool gameStarted = false;
  List<MemoryCard> cards = [];
  int? firstCardIndex;
  int? secondCardIndex;
  int score = 0;
  int moves = 0;
  bool canFlip = true;
  late AnimationController _celebrationController;

  final List<String> emojis = ['🐱', '🐶', '🐼', '🦁', '🐘', '🦊', '🐸', '🐰', '🦄', '🐯', '🐨', '🐵'];
  final List<Color> levelColors = [
    const Color(0xFFFAE2C3),
    const Color(0xFFB3F6AD),
    const Color(0xFFFFD4E5),
  ];

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  void initializeGame(int level) {
    setState(() {
      selectedLevel = level;
      gameStarted = true;
      score = 0;
      moves = 0;
      firstCardIndex = null;
      secondCardIndex = null;
      canFlip = true;

      int pairsCount = level == 1 ? 6 : (level == 2 ? 8 : 12);
      List<String> selectedEmojis = emojis.sublist(0, pairsCount);
      List<String> cardValues = [...selectedEmojis, ...selectedEmojis];
      cardValues.shuffle(Random());

      cards = cardValues
          .asMap()
          .entries
          .map((entry) => MemoryCard(
        id: entry.key,
        value: entry.value,
        isFlipped: false,
        isMatched: false,
      ))
          .toList();
    });
  }

  void onCardTap(int index) {
    if (!canFlip || cards[index].isFlipped || cards[index].isMatched) return;

    setState(() {
      cards[index].isFlipped = true;

      if (firstCardIndex == null) {
        firstCardIndex = index;
      } else if (secondCardIndex == null) {
        secondCardIndex = index;
        moves++;
        canFlip = false;

        Future.delayed(const Duration(milliseconds: 800), () {
          checkMatch();
        });
      }
    });
  }

  void checkMatch() {
    if (cards[firstCardIndex!].value == cards[secondCardIndex!].value) {
      setState(() {
        cards[firstCardIndex!].isMatched = true;
        cards[secondCardIndex!].isMatched = true;
        score += 10;
        firstCardIndex = null;
        secondCardIndex = null;
        canFlip = true;
      });

      if (cards.every((card) => card.isMatched)) {
        _celebrationController.forward().then((_) => _celebrationController.reverse());
        Future.delayed(const Duration(milliseconds: 1500), () {
          showWinDialog();
        });
      }
    } else {
      setState(() {
        cards[firstCardIndex!].isFlipped = false;
        cards[secondCardIndex!].isFlipped = false;
        firstCardIndex = null;
        secondCardIndex = null;
        canFlip = true;
      });
    }
  }

  void showWinDialog() {
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
                  // Image de succès
                  Image.asset(
                    'assets/images/success.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.celebration,
                        size: 120,
                        color: Colors.green,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Message de résultat
                  const Text(
                    'أحسنت !',
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
                    'لقد أكملت اللعبة بنجاح',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontFamily: 'Amiri',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Statistiques
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'النقاط',
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$score',
                                  style: const TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.black26,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'المحاولات',
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$moves',
                                  style: const TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF9800),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Boutons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              gameStarted = false;
                              selectedLevel = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'المستويات',
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
                            initializeGame(selectedLevel!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'إعادة اللعب',
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F8FF),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    const Text(
                      'لعبة الذاكرة',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B9D),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),

              // Game content
              Expanded(
                child: gameStarted ? buildGameBoard() : buildLevelSelection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLevelSelection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'إختر المستوى',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 40),
          ...List.generate(3, (index) {
            int level = index + 1;
            String levelText = level == 1 ? 'المرحلة الأولى' : (level == 2 ? 'المرحلة الثانية' : 'المرحلة الثالثة');
            String difficulty = level == 1 ? 'سهلة' : (level == 2 ? 'متوسطة' : 'صعبة');

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: InkWell(
                onTap: () => initializeGame(level),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: levelColors[index],
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
                        levelText,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Amiri',
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        difficulty,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Amiri',
                          color: const Color(0xFF2C3E50).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildGameBoard() {
    int crossAxisCount = selectedLevel == 1 ? 3 : (selectedLevel == 2 ? 4 : 4);

    return Column(
      children: [
        // Score board
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreCard('النقاط', score.toString(), const Color(0xFF4CAF50)),
              _buildScoreCard('المحاولات', moves.toString(), const Color(0xFFFF9800)),
            ],
          ),
        ),

        // Game grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: cards[index].isMatched
                          ? Colors.green.withOpacity(0.3)
                          : cards[index].isFlipped
                          ? Colors.white
                          : const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: cards[index].isFlipped || cards[index].isMatched
                          ? Text(
                        cards[index].value,
                        style: const TextStyle(fontSize: 40),
                      )
                          : const Icon(Icons.help_outline, color: Colors.white, size: 40),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryCard {
  final int id;
  final String value;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.value,
    required this.isFlipped,
    required this.isMatched,
  });
}