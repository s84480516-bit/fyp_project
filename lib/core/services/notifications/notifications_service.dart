import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler - MUST be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.instance.showLocalNotification(
    title: message.notification?.title ?? 'New Notification',
    body: message.notification?.body ?? '',
    payload: message.data.toString(),
  );
}

/// Main Notification Service - Singleton Pattern
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request permissions
      await requestPermissions();

      // Setup FCM
      await _setupFCM();

      // Listen to foreground messages
      _listenToForegroundMessages();

      _isInitialized = true;
      debugPrint('✅ NotificationService initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing NotificationService: $e');
      rethrow;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannels();
    }
  }

  /// Create Android notification channels
  Future<void> _createAndroidNotificationChannels() async {
    const channels = [
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
      AndroidNotificationChannel(
        'default_channel',
        'Default Notifications',
        description: 'This channel is used for regular notifications.',
        importance: Importance.defaultImportance,
      ),
    ];

    for (final channel in channels) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } else {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
  }

  /// Setup FCM and save token
  Future<void> _setupFCM() async {
    try {
      // Get FCM token
      // ignore: deprecated_member_use
      final token = await _fcm.getToken();
      if (token != null) {
        await _saveFCMToken(token);
      }

      // Listen for token refresh
      // ignore: deprecated_member_use
      _fcm.onTokenRefresh.listen(_saveFCMToken);
    } catch (e) {
      debugPrint('Error setting up FCM: $e');
    }
  }

  /// Save FCM token to Supabase
  Future<void> _saveFCMToken(String token) async {
    /// Implement your logic to save the token to your backend or Supabase
    debugPrint('✅ FCM Token: $token');
  }

  /// Listen to foreground messages
  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        '📨 Foreground message received: ${message.notification?.title}',
      );

      // Show local notification
      showLocalNotification(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: message.data.toString(),
      );
    });

    // Handle notification taps (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
        '📱 Notification tapped (background): ${message.notification?.title}',
      );
      _handleNotificationTap(message.data);
    });
  }

  /// Show local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'high_importance_channel',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Local notification tapped: ${response.payload}');
    if (response.payload != null) {
      // Parse payload and navigate
      _handleNotificationTap({'payload': response.payload});
    }
  }

  /// Handle notification tap navigation
  void _handleNotificationTap(Map<String, dynamic> data) {
    // Implement your navigation logic here
    // Example: navigatorKey.currentState?.pushNamed('/notification-detail', arguments: data);
    debugPrint('Navigation data: $data');
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    _isInitialized = false;
  }
}
