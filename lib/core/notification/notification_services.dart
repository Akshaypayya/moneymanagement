import 'dart:convert';
import 'package:growk_v2/main.dart';

import '../../views.dart';

class NotificationServices {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String androidChannelId = 'growk_channel';
  static const String androidChannelName = 'GrowK Notifications';

  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
    );
    debugPrint('Notification permission status: ${settings.authorizationStatus}');
  }



  Future<void> initLocalNotifications(BuildContext context,WidgetRef ref) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('🔔 Notification tapped with payload: ${response.payload}');
        if (response.payload != null && response.payload!.isNotEmpty) {
          _handleNotificationNavigation(response.payload!, ref); // <-- pass ref here
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        androidChannelId,
        androidChannelName,
        importance: Importance.max,
      ),
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final androidDetails = AndroidNotificationDetails(
      androidChannelId,
      androidChannelName,
      channelDescription: 'Notifications from GrowK',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    String payload = jsonEncode(message.data);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Message Body',
      notificationDetails,
      payload: payload,
    );
  }

  void firebaseInit(BuildContext context, WidgetRef ref) { // <-- Add ref
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('📨 Foreground message received: ${message.data}');
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('📲 App opened via notification: ${message.data}');
      if (message.data.isNotEmpty) {
        String payload = jsonEncode(message.data);
        _handleNotificationNavigation(payload, ref); // <-- pass ref here
      }
    });
  }
  Future<void> handleInitialMessage(WidgetRef ref) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('📲 App opened from terminated state via notification: ${initialMessage.data}');
      String payload = jsonEncode(initialMessage.data);
      _handleNotificationNavigation(payload, ref);
    }
  }


  void _handleNotificationNavigation(String payload, WidgetRef ref) {
    try {
      ref.read(notificationNavigationIndexProvider.notifier).state = 1; // Correctly set in live app scope

      final data = jsonDecode(payload);

      final nav = navigatorKey.currentState;
      if (nav == null) {
        debugPrint('❌ Navigator is not ready yet.');
        return;
      }
      nav.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
            (route) => false,
      );

      debugPrint('✅ Navigated to MainScreen with TransactionsPage via notification.');
    } catch (e) {
      debugPrint('❌ Failed to parse payload: $e');
    }
  }





  Future<String?> getDeviceToken() async {
    final token = await messaging.getToken();
    debugPrint('🔑 FCM Token: $token');
    return token;
  }
}

// Riverpod Provider
final notificationProvider = Provider<NotificationServices>((ref) {
  return NotificationServices();
});
final notificationNavigationIndexProvider = StateProvider<int?>((ref) => null);
