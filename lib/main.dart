import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notificationService.dart';
import 'home_page.dart';
import 'audio_service.dart';
import 'services/local_storage_service.dart'; // AJOUT IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialisation Notifications
  final notificationService = NotificationService();
  await notificationService.init();

  // Test immédiat de notification
  await notificationService.showTestNotification();

  // Planifier les notifications quotidiennes
  await notificationService.scheduleDailyNotifications();

  // AJOUT: Initialisation du stockage local
  await LocalStorageService().init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startMusic();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-planifier les notifications quand l'app revient au premier plan
      NotificationService().scheduleDailyNotifications();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioService.stopBackgroundMusic();
    super.dispose();
  }

  Future<void> _startMusic() async {
    await AudioService.startBackgroundMusic();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bidaya',
      theme: ThemeData(
        fontFamily: 'Cairo',
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}