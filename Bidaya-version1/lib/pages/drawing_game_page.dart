import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DrawingGamePage extends StatefulWidget {
  const DrawingGamePage({super.key});

  @override
  State<DrawingGamePage> createState() => _DrawingGamePageState();
}

class _DrawingGamePageState extends State<DrawingGamePage> {
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
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadDrawingAndStatus();
  }

  void _loadDrawingAndStatus() {
    // Charger le statut de complétion
    final completed = _prefs.getBool('letter_$currentLetterIndex') ?? false;

    // Charger le dessin sauvegardé
    final savedDrawing = _prefs.getString('drawing_$currentLetterIndex');
    List<Offset> loadedPoints = [];

    if (savedDrawing != null) {
      try {
        final List<dynamic> pointsList = jsonDecode(savedDrawing);
        loadedPoints = pointsList.map((point) {
          if (point['isInfinite'] == true) {
            return Offset.infinite;
          }
          return Offset(point['dx'] as double, point['dy'] as double);
        }).toList();
      } catch (e) {
        print('Erreur lors du chargement du dessin: $e');
      }
    }

    setState(() {
      isCompleted = completed;
      points = loadedPoints;
    });
  }

  Future<void> _saveDrawing() async {
    // Convertir les points en format JSON
    final pointsList = points.map((point) {
      if (point == Offset.infinite) {
        return {'isInfinite': true};
      }
      return {'dx': point.dx, 'dy': point.dy, 'isInfinite': false};
    }).toList();

    final jsonString = jsonEncode(pointsList);
    await _prefs.setString('drawing_$currentLetterIndex', jsonString);
  }

  void _clearDrawing() {
    setState(() {
      points.clear();
      isCompleted = false;
    });
    _saveCompletionStatus(false);
    _saveDrawing();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم مسح الرسم',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Amiri'),
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _nextLetter() {
    // Sauvegarder le dessin actuel avant de changer de lettre
    _saveDrawing();

    setState(() {
      currentLetterIndex = (currentLetterIndex + 1) % arabicLetters.length;
      points.clear();
    });

    // Charger le dessin de la nouvelle lettre
    _loadDrawingAndStatus();
  }

  void _previousLetter() {
    // Sauvegarder le dessin actuel avant de changer de lettre
    _saveDrawing();

    setState(() {
      currentLetterIndex = (currentLetterIndex - 1) % arabicLetters.length;
      if (currentLetterIndex < 0) {
        currentLetterIndex = arabicLetters.length - 1;
      }
      points.clear();
    });

    // Charger le dessin de la nouvelle lettre
    _loadDrawingAndStatus();
  }

  Future<void> _markAsCompleted() async {
    final newCompletionStatus = !isCompleted;
    setState(() {
      isCompleted = newCompletionStatus;
    });
    await _saveCompletionStatus(newCompletionStatus);

    // Afficher un message de confirmation
    if (newCompletionStatus) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم حفظ إنجاز الحرف ${arabicLetters[currentLetterIndex]['name']}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Amiri'),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveCompletionStatus(bool completed) async {
    await _prefs.setBool('letter_$currentLetterIndex', completed);
  }

  void _addPoint(Offset point) {
    setState(() {
      points.add(point);
    });
    // Sauvegarder automatiquement après chaque ajout de point
    _saveDrawing();
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = arabicLetters[currentLetterIndex];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'رسم الحروف',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Sauvegarder avant de quitter
              _saveDrawing();
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Titre principal
              const Text(
                'رسم الحروف العربية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Amiri',
                ),
              ),

              const SizedBox(height: 10),

              // Lettre actuelle
              Text(
                '${currentLetter['name']} - ${currentLetter['letter']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // Indicateur de progression
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${currentLetterIndex + 1} / ${arabicLetters.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    const SizedBox(width: 10),
                    // Indicateur de sauvegarde automatique
                    if (points.isNotEmpty)
                      const Icon(
                        Icons.save,
                        color: Colors.blue,
                        size: 16,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Zone de dessin
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade300, width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onPanStart: (details) {
                      _addPoint(details.localPosition);
                    },
                    onPanUpdate: (details) {
                      _addPoint(details.localPosition);
                    },
                    onPanEnd: (details) {
                      _addPoint(Offset.infinite);
                    },
                    child: Stack(
                      children: [
                        // Fond avec la lettre en guide
                        Center(
                          child: Text(
                            currentLetter['letter']!,
                            style: TextStyle(
                              fontSize: 120,
                              color: isCompleted ? Colors.green.shade200 : Colors.grey.shade300,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                        // Dessin de l'utilisateur
                        CustomPaint(
                          size: Size.infinite,
                          painter: DrawingPainter(points: points),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Boutons d'action
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Boutons principaux
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _clearDrawing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.clear, color: Colors.white),
                label: const Text(
                  'مسح الرسم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _markAsCompleted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.green : Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  isCompleted ? Icons.check_circle : Icons.check,
                  color: Colors.white,
                ),
                label: Text(
                  isCompleted ? 'مكتمل' : 'تم الإنجاز',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                  ),
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
              child: ElevatedButton.icon(
                onPressed: _previousLetter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                label: const Text(
                  'الحرف السابق',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _nextLetter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                label: const Text(
                  'الحرف التالي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            ),
          ],
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
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}