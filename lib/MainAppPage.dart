import 'package:flutter/material.dart';
import 'ProfilPage.dart';
import 'JeuxPage.dart';
import 'ExercicesPage.dart';
import 'ChatBotPage.dart'; // page chat bot

class MainAppPage extends StatefulWidget {
  const MainAppPage({Key? key}) : super(key: key);

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProfilPage(),
    const JeuxEducatifApp(),
    const ExercicesPage(),
    const ConversationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFFF6B9D),
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 26),
                activeIcon: Icon(Icons.person, size: 28),
                label: 'الملف الشخصي',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.gamepad_outlined, size: 26),
                activeIcon: Icon(Icons.gamepad, size: 28),
                label: 'الألعاب',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center_outlined, size: 26),
                activeIcon: Icon(Icons.fitness_center, size: 28),
                label: 'التمارين',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline, size: 26),
                activeIcon: Icon(Icons.chat_bubble, size: 28),
                label: 'الدردشة', // <-- label en arabe
              ),
            ],
          ),
        ),
      ),
    );
  }
}
