import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<String> messages = [
    "تذكير: حان وقت الدراسة 📚",
    "اقرأ قصة قصيرة الآن! ✏️",
    "لنلعب ونكتسب المعرفة 🌟",
    "وقت التعلم ممتع 🧠",
    "هل تريد اختبار صغير؟ 😉",
    "استمر في التعلم، أنت رائع! 🎉"
  ];

  final List<Color> colors = [
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.yellowAccent
  ];

  static const String customNotificationIcon = 'ic_launcher';

  Future<void> init() async {
    try {
      // Initialisation timezone
      tz.initializeTimeZones();
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));

      // SOLUTION 2: Utiliser AndroidInitializationSettings sans paramètre pour l'icône par défaut
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Création du canal Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'bidaya_channel',
        'إشعارات بداية',
        description: 'تذكيرات لتطبيق بداية التعليمي للأطفال',
        importance: Importance.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Demander les permissions
      await _requestPermissions();

      print('Service de notifications initialisé avec succès');
    } catch (e) {
      print('Erreur lors de l\'initialisation des notifications: $e');
      // Essayer sans icône spécifique
      await _initializeWithoutCustomIcon();
    }
  }

  Future<void> _initializeWithoutCustomIcon() async {
    try {
      // SOLUTION 3: Utiliser le nom d'icône par défaut de Flutter
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      );

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      print('Notifications initialisées avec icône par défaut');
    } catch (e) {
      print('Échec de l\'initialisation: $e');
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        print('Permission notifications accordée sur Android');
      } else {
        print('Permission notifications refusée sur Android');
      }
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    print("Notification tapée: ${response.id}");
  }

  /// Notification test immédiate
  Future<void> showTestNotification() async {
    try {
      // SOLUTION 4: Utiliser un nom d'icône simple
      const String iconName = 'ic_launcher'; // ou 'notification_icon'

      await flutterLocalNotificationsPlugin.show(
        0,
        'بداية ✨',
        messages[0],
        NotificationDetails(
          android: AndroidNotificationDetails(
            'bidaya_channel',
            'إشعارات بداية',
            channelDescription: 'تذكيرات لتطبيق بداية التعليمي للأطفال',
            importance: Importance.high,
            priority: Priority.high,
            icon: iconName,
            color: colors[0],
            enableVibration: true,
            autoCancel: true,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'default',
          ),
        ),
      );
      print('Notification de test envoyée avec succès');
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification de test: $e');
      // Essayer sans icône personnalisée
      await _showNotificationWithoutIcon();
    }
  }

  Future<void> _showNotificationWithoutIcon() async {
    try {
      await flutterLocalNotificationsPlugin.show(
        1, // ID différent
        'بداية ✨',
        'Test sans icône personnalisée',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'bidaya_channel',
            'إشعارات بداية',
            channelDescription: 'تذكيرات لتطبيق بداية التعليمي للأطفال',
            importance: Importance.high,
            priority: Priority.high,
            // Ne pas spécifier 'icon' pour utiliser l'icône par défaut
            color: colors[0],
            enableVibration: true,
            autoCancel: true,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'default',
          ),
        ),
      );
      print('Notification sans icône personnalisée envoyée');
    } catch (e) {
      print('Échec de la notification sans icône: $e');
    }
  }

  /// Notifications quotidiennes toutes les 3h de 7h à 22h
  Future<void> scheduleDailyNotifications() async {
    try {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      int notifId = 10; // Commencer à 10 pour éviter les conflits

      for (int hour = 7; hour <= 22; hour += 3) {
        tz.TZDateTime scheduledDate =
            tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, 0, 0);

        // Si l'heure est passée, planifier pour demain
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        final androidDetails = AndroidNotificationDetails(
          'bidaya_channel',
          'إشعارات بداية',
          channelDescription: 'تذكيرات لتطبيق بداية التعليمي للأطفال',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_launcher', // Utiliser le même nom
          color: colors[notifId % colors.length],
          enableVibration: true,
          autoCancel: true,
          playSound: true,
        );

        final iosDetails = const DarwinNotificationDetails(
          sound: 'default',
        );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          notifId,
          'بداية ✨',
          messages[notifId % messages.length],
          scheduledDate,
          NotificationDetails(android: androidDetails, iOS: iosDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );

        print('Notification $notifId planifiée pour $scheduledDate');
        notifId++;
      }
      print('Toutes les notifications quotidiennes ont été planifiées');
    } catch (e) {
      print('Erreur lors de la planification des notifications: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('Toutes les notifications ont été annulées');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print('Notification $id annulée');
  }
}
