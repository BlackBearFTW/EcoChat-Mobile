import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() => _notificationService;
  NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails _androidNotificationDetails = const AndroidNotificationDetails(
    'channel ID',
    'Algemeen',
    color: Color(0xFF8CC63F),
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
    onlyAlertOnce: true,
    styleInformation: BigTextStyleInformation('')
  );

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (_) {});
  }

  Future<void> showNotifications(String title, String content) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      content,
      NotificationDetails(android: _androidNotificationDetails),
    );
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}