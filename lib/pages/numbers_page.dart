import 'package:flutter/material.dart';
import 'NumbersGamePage.dart';
import 'NumberComparisonGame.dart';

class PageNumbersPage extends StatelessWidget {
  const PageNumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FBFA), // Fond vert clair pastel
        appBar: AppBar(
          backgroundColor: const Color(0xFF5D83FA),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'لعبة الأرقام',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Amiri',
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Titre principal
                const Text(
                  'اختر اللعبة التي تريد لعبها',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D83FA),
                    fontFamily: 'Amiri',
                  ),
                ),

                const SizedBox(height: 40),

                // Carte rose - Comparaison
                _buildNumberCard(
                  context,
                  imagePath: 'assets/images/1.png',
                  title: 'المقارنة بين الأعداد',
                  color: const Color(0xFFFAF5C7),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ComparisonGamePage()),
                    );
                  },
                ),

                const SizedBox(height: 25),

                // Carte bleue - Comptage
                _buildNumberCard(
                  context,
                  imagePath: 'assets/images/2.jpg',
                  title: 'عد العصي',
                  color: const Color(0xFFF6C6E0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CountingSticksGamePage()),
                    );
                  },
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberCard(
      BuildContext context, {
        required String imagePath,
        required String title,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image au centre
              if (imagePath.isNotEmpty)
                Image.asset(
                  imagePath,
                  width: 90,
                  height: 90,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.games,
                      size: 90,
                      color: Colors.black54,
                    );
                  },
                ),
              const SizedBox(height: 15),
              // Texte en bas
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}