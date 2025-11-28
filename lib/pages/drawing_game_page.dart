import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawingGamePage extends StatefulWidget {
  const DrawingGamePage({super.key});

  @override
  State<DrawingGamePage> createState() => _DrawingGamePageState();
}

class _DrawingGamePageState extends State<DrawingGamePage> {
  // Liste des lettres arabes avec leurs noms
  final List<Map<String, String>> arabicLetters = [
    {'letter': 'أ', 'name': 'الألف'},
    {'letter': 'ب', 'name': 'الباء'},
    {'letter': 'ت', 'name': 'التاء'},
    {'letter': 'ث', 'name': 'الثاء'},
    {'letter': 'ج', 'name': 'الجيم'},
    {'letter': 'ح', 'name': 'الحاء'},
    {'letter': 'خ', 'name': 'الخاء'},
    {'letter': 'د', 'name': 'الدال'},
    {'letter': 'ذ', 'name': 'الذال'},
    {'letter': 'ر', 'name': 'الراء'},
    {'letter': 'ز', 'name': 'الزاي'},
    {'letter': 'س', 'name': 'السين'},
    {'letter': 'ش', 'name': 'الشين'},
    {'letter': 'ص', 'name': 'الصاد'},
    {'letter': 'ض', 'name': 'الضاد'},
    {'letter': 'ط', 'name': 'الطاء'},
    {'letter': 'ظ', 'name': 'الظاء'},
    {'letter': 'ع', 'name': 'العين'},
    {'letter': 'غ', 'name': 'الغين'},
    {'letter': 'ف', 'name': 'الفاء'},
    {'letter': 'ق', 'name': 'القاف'},
    {'letter': 'ك', 'name': 'الكاف'},
    {'letter': 'ل', 'name': 'اللام'},
    {'letter': 'م', 'name': 'الميم'},
    {'letter': 'ن', 'name': 'النون'},
    {'letter': 'ه', 'name': 'الهاء'},
    {'letter': 'و', 'name': 'الواو'},
    {'letter': 'ي', 'name': 'الياء'},
  ];

  int currentLetterIndex = 0;
  List<Offset> points = [];
  bool isCompleted = false;

  void _clearDrawing() {
    setState(() {
      points.clear();
      isCompleted = false;
    });
  }

  void _nextLetter() {
    setState(() {
      currentLetterIndex = (currentLetterIndex + 1) % arabicLetters.length;
      points.clear();
      isCompleted = false;
    });
  }

  void _previousLetter() {
    setState(() {
      currentLetterIndex = (currentLetterIndex - 1) % arabicLetters.length;
      if (currentLetterIndex < 0) {
        currentLetterIndex = arabicLetters.length - 1;
      }
      points.clear();
      isCompleted = false;
    });
  }

  void _markAsCompleted() {
    setState(() {
      isCompleted = !isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = arabicLetters[currentLetterIndex];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('رسم الحروف'),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête avec l'heure
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),


              ),

              const SizedBox(height: 20),

              // Titre principal
              const Text(
                'رسم الحروف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Amiri',
                ),
              ),

              const SizedBox(height: 10),

              // Sous-titre avec le nom de la lettre
              Text(
                '${currentLetter['name']} - ${currentLetter['letter']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontFamily: 'Amiri',
                ),
              ),

              const SizedBox(height: 30),

              // Zone de dessin
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade50,
                  ),
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        points.add(details.localPosition);
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        points.add(details.localPosition);
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        points.add(Offset.infinite);
                      });
                    },
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: DrawingPainter(points: points),
                      child: Center(
                        child: Text(
                          currentLetter['letter']!,
                          style: const TextStyle(
                            fontSize: 120,
                            color: Colors.grey,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Cases à cocher comme dans l'image
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),

              ),

              const SizedBox(height: 20),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _clearDrawing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.clear, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'مسح',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _markAsCompleted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted ? Colors.green : Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle : Icons.check,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCompleted ? 'مكتمل' : 'تم',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Navigation entre les lettres
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _previousLetter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'السابق',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextLetter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'التالي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Amiri',
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        ],
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
  }

  Widget _buildCheckboxItem(String letter, bool isCurrent) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: isCurrent ? Colors.blue : Colors.grey,
              width: isCurrent ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isCurrent ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 18,
                color: isCurrent ? Colors.blue : Colors.grey,
                fontFamily: 'Amiri',
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
            color: isCurrent ? Colors.blue : Colors.transparent,
          ),
          child: isCurrent
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}