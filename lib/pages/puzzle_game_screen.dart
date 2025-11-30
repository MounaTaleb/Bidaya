import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'puzzle_page.dart';
import 'local_storage_service.dart';

class PuzzleGameScreen extends StatefulWidget {
  final PuzzleItem puzzle;

  const PuzzleGameScreen({super.key, required this.puzzle});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class PuzzlePiece {
  final int id;
  final int correctPosition;
  final String imagePath;
  final int pieceNumber;
  int currentPosition;
  bool isPlaced;

  PuzzlePiece({
    required this.id,
    required this.correctPosition,
    required this.imagePath,
    required this.pieceNumber,
    this.currentPosition = -1,
    this.isPlaced = false,
  });

  PuzzlePiece copyWith({
    int? currentPosition,
    bool? isPlaced,
  }) {
    return PuzzlePiece(
      id: id,
      correctPosition: correctPosition,
      imagePath: imagePath,
      pieceNumber: pieceNumber,
      currentPosition: currentPosition ?? this.currentPosition,
      isPlaced: isPlaced ?? this.isPlaced,
    );
  }
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  List<PuzzlePiece> availablePieces = [];
  List<PuzzlePiece> placedPieces = [];
  bool isCompleted = false;
  int score = 0;
  int moves = 0;
  PuzzlePiece? selectedPiece;
  ui.Image? fullImage;
  DateTime? startTime;
  Duration? completionTime;

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
    _loadImage();
    startTime = DateTime.now();
  }

  Future<void> _loadImage() async {
    final data = await rootBundle.load(widget.puzzle.imagePath);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    setState(() {
      fullImage = image;
    });
  }

  void _initializePuzzle() {
    availablePieces = [];
    placedPieces = [];
    moves = 0;

    for (int i = 0; i < widget.puzzle.pieces; i++) {
      availablePieces.add(PuzzlePiece(
        id: i,
        correctPosition: i,
        imagePath: widget.puzzle.imagePath,
        pieceNumber: i + 1,
      ));
    }

    availablePieces.shuffle();
  }

  void _onPieceSelected(PuzzlePiece piece) {
    setState(() {
      selectedPiece = piece;
    });
  }

  int _convertRTLPositionToLogical(int displayPosition, int gridSize) {
    final row = displayPosition ~/ gridSize;
    final col = displayPosition % gridSize;
    final invertedCol = gridSize - 1 - col;
    return row * gridSize + invertedCol;
  }

  void _onDropZoneTap(int displayPosition) {
    if (selectedPiece != null && !_isPositionOccupied(displayPosition)) {
      final logicalPosition = _convertRTLPositionToLogical(displayPosition, _getGridSize());

      setState(() {
        final pieceToPlace = selectedPiece!;
        placedPieces.add(pieceToPlace.copyWith(
          currentPosition: displayPosition,
          isPlaced: true,
        ));

        availablePieces.removeWhere((p) => p.id == pieceToPlace.id);

        if (logicalPosition == pieceToPlace.correctPosition) {
          score += 10;
        }

        moves++;
        selectedPiece = null;
      });

      _checkCompletion();
    }
  }

  bool _isPositionOccupied(int position) {
    return placedPieces.any((piece) => piece.currentPosition == position);
  }

  void _checkCompletion() {
    if (placedPieces.length == widget.puzzle.pieces) {
      bool allCorrect = true;
      final gridSize = _getGridSize();

      for (var piece in placedPieces) {
        final logicalPosition = _convertRTLPositionToLogical(piece.currentPosition, gridSize);
        if (logicalPosition != piece.correctPosition) {
          allCorrect = false;
          break;
        }
      }

      if (allCorrect) {
        completionTime = DateTime.now().difference(startTime!);

        // Bonus de temps et de mouvements
        final timeBonus = (300 - completionTime!.inSeconds).clamp(0, 100);
        final movesBonus = (50 - moves).clamp(0, 50);

        setState(() {
          isCompleted = true;
          score += 50 + timeBonus + movesBonus;
        });

        // Sauvegarder le score
        LocalStorageService.savePuzzleScore(widget.puzzle.id, score);

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showCompletionDialog();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'جميع القطع موضوعة ولكن ليست في الأماكن الصحيحة!',
              style: TextStyle(fontFamily: 'Amiri'),
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _removePlacedPiece(PuzzlePiece piece) {
    final gridSize = _getGridSize();
    final logicalPosition = _convertRTLPositionToLogical(piece.currentPosition, gridSize);

    setState(() {
      placedPieces.removeWhere((p) => p.id == piece.id);
      availablePieces.add(piece.copyWith(
        currentPosition: -1,
        isPlaced: false,
      ));

      if (logicalPosition == piece.correctPosition) {
        score -= 10;
      }
      moves++;
    });
  }

  void _showCompletionDialog() {
    if (!mounted) return;

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
                    'لقد أكملت البازل بنجاح',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontFamily: 'Amiri',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Statistiques détaillées
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.puzzle.title,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildStatRow('الوقت:', '${completionTime!.inMinutes}:${(completionTime!.inSeconds % 60).toString().padLeft(2, '0')}'),
                        _buildStatRow('الحركات:', '$moves'),
                        _buildStatRow('النقاط:', '$score', isScore: true),

                        const SizedBox(height: 8),

                        FutureBuilder<Map<String, int>>(
                          future: LocalStorageService.getHighScores(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final puzzleIdString = widget.puzzle.id.toString(); // Convertir en String
                              final highScore = snapshot.data![puzzleIdString] ?? 0;
                              final isNewHighScore = score > highScore;

                              if (isNewHighScore) {
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'أفضل نتيجة جديدة!',
                                        style: TextStyle(
                                          fontFamily: 'Amiri',
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            return const SizedBox();
                          },
                        ),                      ],
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
                            Navigator.of(context).pop();
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
                            _resetGame();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'العب مجدداً',
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

  Widget _buildStatRow(String label, String value, {bool isScore = false}) {
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
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: isScore ? 20 : 16,
              fontWeight: isScore ? FontWeight.bold : FontWeight.normal,
              color: isScore ? const Color(0xFF4CAF50) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      isCompleted = false;
      score = 0;
      moves = 0;
      selectedPiece = null;
      startTime = DateTime.now();
      completionTime = null;
      _initializePuzzle();
    });
  }

  int _getGridSize() {
    switch (widget.puzzle.pieces) {
      case 4:
        return 2;
      case 6:
        return 3;
      case 8:
        return 3;
      case 9:
        return 3;
      case 12:
        return 4;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = _getGridSize();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.puzzle.title),
          backgroundColor: widget.puzzle.backgroundColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetGame,
              tooltip: 'إعادة تشغيل',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildScoreHeader(),
              _buildInstructions(),
              _buildReferenceImage(),
              _buildGameArea(gridSize),
              _buildAvailablePieces(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.puzzle.backgroundColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: widget.puzzle.backgroundColor, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem('النقاط', '$score', Icons.stars),
          _buildScoreItem('الحركات', '$moves', Icons.touch_app),
          _buildScoreItem(
              'الوقت',
              startTime != null
                  ? '${DateTime.now().difference(startTime!).inMinutes}:${(DateTime.now().difference(startTime!).inSeconds % 60).toString().padLeft(2, '0')}'
                  : '0:00',
              Icons.timer
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: widget.puzzle.backgroundColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.puzzle.backgroundColor,
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

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        isCompleted
            ? '🎉 مبروك! أكملت البازل!'
            : 'اختر قطعة ثم انقر على مكانها الصحيح',
        style: TextStyle(
          fontFamily: 'Amiri',
          fontSize: 16,
          color: isCompleted ? Colors.green : Colors.grey[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReferenceImage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const Text(
            'الصورة المرجعية',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: widget.puzzle.backgroundColor, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.puzzle.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea(int gridSize) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!, width: 3),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    _buildDropZoneGrid(gridSize),
                    ..._buildPlacedPieces(gridSize, constraints.maxWidth),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropZoneGrid(int gridSize) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: widget.puzzle.pieces,
      itemBuilder: (context, index) {
        return _buildDropZone(index);
      },
    );
  }

  List<Widget> _buildPlacedPieces(int gridSize, double containerWidth) {
    return placedPieces.map((piece) {
      final cellSize = containerWidth / gridSize;
      final row = piece.currentPosition ~/ gridSize;
      final col = piece.currentPosition % gridSize;

      final double leftPosition = (containerWidth - (col + 1) * cellSize) + 1;

      return Positioned(
        left: leftPosition,
        top: row * cellSize + 1,
        width: cellSize - 2,
        height: cellSize - 2,
        child: _buildPlacedPiece(piece, gridSize, cellSize - 2),
      );
    }).toList();
  }

  Widget _buildDropZone(int position) {
    final isOccupied = _isPositionOccupied(position);

    return GestureDetector(
      onTap: () => _onDropZoneTap(position),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isOccupied ? Colors.green : Colors.grey[400]!,
            width: 2,
          ),
          color: isOccupied
              ? Colors.transparent
              : Colors.grey[100]!.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildAvailablePieces() {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text(
            'القطع المتاحة',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availablePieces.length,
              itemBuilder: (context, index) {
                return _buildAvailablePiece(availablePieces[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePiece(PuzzlePiece piece) {
    final isSelected = selectedPiece?.id == piece.id;
    final gridSize = _getGridSize();

    return GestureDetector(
      onTap: () => _onPieceSelected(piece),
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? widget.puzzle.backgroundColor : Colors.grey[400]!,
            width: isSelected ? 4 : 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: _buildPieceImage(piece.correctPosition, gridSize),
        ),
      ),
    );
  }

  Widget _buildPlacedPiece(PuzzlePiece piece, int gridSize, double size) {
    return GestureDetector(
      onTap: () => _removePlacedPiece(piece),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ClipRect(
          child: _buildPieceImage(piece.correctPosition, gridSize),
        ),
      ),
    );
  }

  Widget _buildPieceImage(int piecePosition, int gridSize) {
    if (fullImage == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomPaint(
      painter: PuzzlePiecePainter(
        image: fullImage!,
        piecePosition: piecePosition,
        gridSize: gridSize,
      ),
      child: Container(),
    );
  }
}

class PuzzlePiecePainter extends CustomPainter {
  final ui.Image image;
  final int piecePosition;
  final int gridSize;

  PuzzlePiecePainter({
    required this.image,
    required this.piecePosition,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final row = piecePosition ~/ gridSize;
    final col = piecePosition % gridSize;

    final pieceWidth = image.width / gridSize;
    final pieceHeight = image.height / gridSize;

    final srcRect = Rect.fromLTWH(
      col * pieceWidth,
      row * pieceHeight,
      pieceWidth,
      pieceHeight,
    );

    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant PuzzlePiecePainter oldDelegate) {
    return oldDelegate.piecePosition != piecePosition ||
        oldDelegate.gridSize != gridSize;
  }
}