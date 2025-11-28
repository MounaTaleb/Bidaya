import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  // Icône personnalisée de la notification
  static const String customNotificationIcon = '@mipmap/ic_launcher';
  // Image mignonne pour BigPicture
  static const String cuteImage =
      'cute_image'; // placer cute_image.png dans res/drawable/

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(customNotificationIcon);

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'bidaya_channel',
      'إشعارات بداية',
      description: 'تذكيرات لتطبيق بداية التعليمي للأطفال',
      importance: Importance.max,
      enableLights: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Notification test immédiate
  Future<void> showTestNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'بداية ✨',
      messages[0],
      NotificationDetails(
        android: AndroidNotificationDetails(
          'bidaya_channel',
          'إشعارات بداية',
          channelDescription: 'تذكيرات لتطبيق بداية التعليمي للأطفال',
          importance: Importance.max,
          priority: Priority.high,
          icon: customNotificationIcon,
          color: colors[0],
          enableVibration: true,
          styleInformation: BigPictureStyleInformation(
            const DrawableResourceAndroidBitmap(cuteImage),
            largeIcon:
                const DrawableResourceAndroidBitmap(customNotificationIcon),
            contentTitle: 'بداية ✨',
            summaryText: 'تذكير تعليمي',
          ),
          autoCancel: true,
        ),
      ),
    );
  }

  /// Notifications quotidiennes toutes les 3h de 7h à 22h
  Future<void> scheduleDailyNotifications() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    int notifId = 1;

    for (int hour = 7; hour <= 22; hour += 3) {
      tz.TZDateTime scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, 0);

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final androidDetails = AndroidNotificationDetails(
        'bidaya_channel',
        'إشعارات بداية',
        channelDescription: 'تذكيرات لتطبيق بداية التعليمي للأطفال',
        importance: Importance.max,
        priority: Priority.high,
        icon: customNotificationIcon,
        color: colors[notifId % colors.length],
        enableVibration: true,
        styleInformation: BigPictureStyleInformation(
          const DrawableResourceAndroidBitmap(cuteImage),
          largeIcon:
              const DrawableResourceAndroidBitmap(customNotificationIcon),
          contentTitle: 'بداية ✨',
          summaryText: messages[notifId % messages.length],
        ),
        autoCancel: true,
        timeoutAfter: 5000,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notifId,
        'بداية ✨',
        messages[notifId % messages.length],
        scheduledDate,
        NotificationDetails(android: androidDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      notifId++;
    }
  }
}
