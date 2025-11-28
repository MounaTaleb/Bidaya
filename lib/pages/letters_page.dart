import 'package:flutter/material.dart';
import 'missing_letter_game_page.dart';
import 'drawing_game_page.dart';


class LettersPage extends StatelessWidget {
  const LettersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لعبة الحروف'),
          backgroundColor: Colors.pinkAccent,
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

              const SizedBox(height: 30),

              // Titre principal
              const Text(
                'لعبة الحروف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                  fontFamily: 'Amiri',
                ),
              ),

              const SizedBox(height: 50),

              // Carte pour le jeu "رسم الحروف"
              _buildGameCard(
                title: 'رسم الحروف',
                subtitle: 'تعلم كتابة الحروف العربية',
                icon: Icons.edit,
                color: Colors.blue,
                onTap: () {
                  _navigateToDrawingGame(context);
                },
              ),

              const SizedBox(height: 30),

              // Carte pour le jeu "الحرف المفقودة"
              _buildGameCard(
                title: 'الحرف المفقودة',
                subtitle: 'اكتشف الحرف الناقص',
                icon: Icons.search,
                color: Colors.green,
                onTap: () {
                  _navigateToMissingLetterGame(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.3),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDrawingGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DrawingGamePage()),
    );
    // TODO: Implémenter la navigation vers l'écran du jeu de dessin
    // Navigator.push(context, MaterialPageRoute(builder: (context) => DrawingGamePage()));
  }

  void _navigateToMissingLetterGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MissingLetterGamePage()),
    );
    // TODO: Implémenter la navigation vers l'écran du jeu des lettres manquantes
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MissingLetterGamePage()));
  }
}