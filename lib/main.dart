<<<<<<< HEAD
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const EducationalApp());
}

class EducationalApp extends StatelessWidget {
  const EducationalApp({super.key});
=======
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'notificationservice.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialisation Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Initialisation notifications (conservé)
  final notificationService = NotificationService();
  await notificationService.init();

  // ✅ Planification notifications 7h → 22h toutes les 3 heures (conservé)
  await notificationService.scheduleDailyNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'تطبيق تعليمي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFF6A89CC),
      ),
      home: HomeScreen(),
    );
  }
}
=======
      debugShowCheckedModeBanner: false,
      title: 'Bidaya',
      theme: ThemeData(
        fontFamily: 'Cairo',
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

// ✅ Widget de vérification d'authentification (optimisé)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // En attente de vérification
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Utilisateur connecté et email vérifié
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;

          if (user.emailVerified ||
              user.providerData.any((p) => p.providerId == 'google.com')) {
            return const HomePage();
          }
        }

        // Pas d'utilisateur ou email non vérifié
        return const HomePage();
      },
    );
  }
}
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c
