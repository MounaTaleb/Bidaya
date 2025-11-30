import 'package:flutter/material.dart';
import 'puzzle_game_screen.dart';

class PuzzleItem {
  final int id;
  final String title;
  final String difficulty;
  final String imagePath;
  final int pieces;
  final Color backgroundColor;

  PuzzleItem({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.imagePath,
    required this.pieces,
    required this.backgroundColor,
  });
}

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final List<PuzzleItem> puzzles = [
    PuzzleItem(
      id: 1,
      title: 'حيوانات المزرعة',
      difficulty: 'سهل',
      imagePath: 'assets/images/puzzle1.png',
      pieces: 4,
      backgroundColor: Colors.green,
    ),
    PuzzleItem(
      id: 2,
      title: 'الحروف العربية',
      difficulty: 'متوسط',
      imagePath: 'assets/images/puzzle2.png',
      pieces: 9,
      backgroundColor: Colors.blue,
    ),
    PuzzleItem(
      id: 3,
      title: 'الفواكه',
      difficulty: 'سهل',
      imagePath: 'assets/images/puzzle3.png',
      pieces: 9,
      backgroundColor: Colors.orange,
    ),
    PuzzleItem(
      id: 4,
      title: 'المركبات',
      difficulty: 'صعب',
      imagePath: 'assets/images/puzzle4.png',
      pieces: 9,
      backgroundColor: Colors.red,
    ),
    PuzzleItem(
      id: 5,
      title: 'الأرقام',
      difficulty: 'متوسط',
      imagePath: 'assets/images/puzzle5.png',
      pieces: 9,
      backgroundColor: Colors.purple,
    ),
    PuzzleItem(
      id: 6,
      title: 'الأشكال',
      difficulty: 'سهل',
      imagePath: 'assets/images/puzzle6.png',
      pieces: 9,
      backgroundColor: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'لعبة بازل',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Amiri',
            ),
          ),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Column(
          children: [
            _buildHeader(),
            _buildPuzzleGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        children: [
          Text(
            'اختر البازل الذي تريد لعبه',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF3663A),
              fontFamily: 'Amiri',
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPuzzleGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: puzzles.length,
          itemBuilder: (context, index) {
            return _buildPuzzleCard(puzzles[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPuzzleCard(PuzzleItem puzzle) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => _startPuzzleGame(context, puzzle),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                puzzle.backgroundColor.withOpacity(0.7),
                puzzle.backgroundColor.withOpacity(0.9),
              ],
            ),
          ),
          child: Stack(
            children: [
              _buildPuzzleImage(puzzle), // ✅ affichage normal
              _buildPuzzleContent(puzzle),
              if (puzzle.id <= 2) _buildNewBadge(),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Correction : affichage normal sans inversion
  Widget _buildPuzzleImage(PuzzleItem puzzle) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          puzzle.imagePath,
          color: Colors.black.withOpacity(0.3),
          colorBlendMode: BlendMode.darken,
        ),
      ),
    );
  }

  Widget _buildPuzzleContent(PuzzleItem puzzle) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPuzzleInfo(puzzle),
        ],
      ),
    );
  }

  Widget _buildPuzzleInfo(PuzzleItem puzzle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          puzzle.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Amiri',
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.grid_view, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              '${puzzle.pieces} قطعة',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Amiri',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewBadge() {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _startPuzzleGame(BuildContext context, PuzzleItem puzzle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(
              'بدء البازل',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('هل تريد بدء بازل "${puzzle.title}"؟\n\n'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    color: Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToGameScreen(context, puzzle);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: puzzle.backgroundColor,
                ),
                child: const Text(
                  'بدء اللعبة',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToGameScreen(BuildContext context, PuzzleItem puzzle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PuzzleGameScreen(puzzle: puzzle),
      ),
    );
  }
}
