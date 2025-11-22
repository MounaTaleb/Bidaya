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
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: const Color(0xFF5D83FA),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF5D83FA), const Color(0xFF4A6FE8)],
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
                'لعبة الأرقام',
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Titre principal avec icône
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.purple.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.casino,
                          color: const Color(0xFF5D83FA),
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        const Flexible(
                          child: Text(
                            'اختر اللعبة التي تريد لعبها',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D83FA),
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Carte 1 - Comparaison
                  _buildNumberCard(
                    context,
                    icon: Icons.compare_arrows,
                    title: 'المقارنة بين الأعداد',
                    description: 'قارن الأعداد واختر العلامة الصحيحة',
                    gradientColors: [const Color(0xFFFFF9C4), const Color(0xFFFFEB3B)],
                    iconColor: Colors.orange.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ComparisonGamePage()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Carte 2 - Comptage
                  _buildNumberCard(
                    context,
                    icon: Icons.format_list_numbered,
                    title: 'عد العصي',
                    description: 'عد العصي الملونة واختر الرقم الصحيح',
                    gradientColors: [const Color(0xFFF8BBD0), const Color(0xFFEC407A)],
                    iconColor: Colors.pink.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CountingSticksGamePage()),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Carte d'information

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required List<Color> gradientColors,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
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
                  size: 45,
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
                        color: Colors.black87,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7),
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
              // Flèche
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}