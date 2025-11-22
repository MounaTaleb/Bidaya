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
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.pink.shade400],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'لعبة الحروف',
                style: TextStyle(
                  fontSize: 24,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Titre principal avec icône
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade50, Colors.purple.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const SizedBox(width: 12),
                        const Flexible(
                          child: Text(
                            'اختر اللعبة التي تريد لعبها',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Carte 1 - رسم الحروف
                  _buildGameCard(
                    title: 'رسم الحروف',
                    subtitle: 'تعلم كتابة الحروف العربية بطريقة ممتعة',
                    icon: Icons.draw,
                    gradientColors: [Colors.blue.shade100, Colors.blue.shade400],
                    iconColor: Colors.blue.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DrawingGamePage()),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Carte 2 - الحرف المفقود
                  _buildGameCard(
                    title: 'الحرف المفقود',
                    subtitle: 'اكتشف الحرف الناقص وأكمل الكلمة',
                    icon: Icons.search,
                    gradientColors: [Colors.green.shade100, Colors.green.shade400],
                    iconColor: Colors.green.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MissingLetterGamePage()),
                      );
                    },
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: gradientColors[1].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icône dans un cercle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 20),
              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
              // Flèche
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Amiri',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontFamily: 'Amiri',
          ),
        ),
      ],
    );
  }
}