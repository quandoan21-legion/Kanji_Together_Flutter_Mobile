// This file sets up notification permissions and listeners.
// It keeps notification code out of the UI layer.

// This gives access to push notification APIs.
import 'package:firebase_messaging/firebase_messaging.dart';
// This gives access to debugPrint for simple logging.
import 'package:flutter/foundation.dart';
// This gives access to local notification APIs.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This provides the Android notification channel settings.
import 'notification_constants.dart';

// This class wraps all notification setup steps.
class NotificationInitializer {
  // This allows dependency injection for testing if needed.
  NotificationInitializer({
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  // This plugin shows local notifications on the device.
  final FlutterLocalNotificationsPlugin _localNotifications;

  // This runs the full notification setup flow.
  Future<void> initialize() async {
    // This connects the local notifications plugin to the app.
    await _initializeLocalNotifications();

    // This creates the Android notification channel.
    await _createAndroidChannel();

    // This asks the user for permission to show notifications.
    await _requestNotificationPermission();

    // This logs the device token used for push notifications.
    await _logFcmToken();

    // This listens for notifications while the app is open.
    _listenForForegroundMessages();

    // This listens for the user opening notifications.
    _listenForNotificationOpens();

    // This checks if the app was opened from a terminated state.
    await _checkInitialMessage();
  }

  // This sets up the local notifications plugin.
  Future<void> _initializeLocalNotifications() async {
    // This picks the Android app icon for notifications.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // This bundles the platform settings together.
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    // This initializes the plugin and listens for taps.
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
  }

  // This creates the Android notification channel if possible.
  Future<void> _createAndroidChannel() async {
    // This grabs the Android-specific plugin.
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    // This creates the channel on Android devices.
    await androidPlugin?.createNotificationChannel(kHighImportanceChannel);

    // This requests Android notification permission when required.
    await androidPlugin?.requestNotificationsPermission();
  }

  // This asks the system for notification permissions.
  Future<void> _requestNotificationPermission() async {
    // This shows the OS permission prompt for notifications.
    final NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      // This allows alert popups.
      alert: true,
      // This does not use announcement permissions.
      announcement: false,
      // This allows badge counts on the app icon.
      badge: true,
      // This does not use CarPlay.
      carPlay: false,
      // This does not use critical alerts.
      criticalAlert: false,
      // This does not use provisional permissions.
      provisional: false,
      // This enables sounds for notifications.
      sound: true,
    );

    // This logs the permission status for debugging.
    debugPrint('Notification permission: ${settings.authorizationStatus}');
  }

  // This logs the FCM token for debugging or backend setup.
  Future<void> _logFcmToken() async {
    // This retrieves the push notification token for the device.
    final String? token = await FirebaseMessaging.instance.getToken();

    // This prints the token so developers can copy it.
    debugPrint('FCM Token: $token');
  }

  // This listens for push messages while the app is open.
  void _listenForForegroundMessages() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  // This listens for taps when the app was in background.
  void _listenForNotificationOpens() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationOpenFromBackground,
    );
  }

  // This checks for a message that opened the app from a closed state.
  Future<void> _checkInitialMessage() async {
    // This gets the message if the app launched from a notification.
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // This logs the message id if the app was opened by a notification.
    if (initialMessage != null) {
      debugPrint(
        'Notification opened from terminated: ${initialMessage.messageId}',
      );
    }
  }

  // This runs when a user taps a local notification.
  void _handleNotificationTap(NotificationResponse response) {
    // This logs the payload for simple debugging.
    debugPrint('Notification tapped: ${response.payload}');
  }

  // This handles messages when the app is in the foreground.
  void _handleForegroundMessage(RemoteMessage message) {
    // This grabs the notification object from the message.
    final RemoteNotification? notification = message.notification;

    // This gets Android-specific notification data.
    final AndroidNotification? android = message.notification?.android;

    // This stops early if the message has no displayable notification.
    if (notification == null || android == null) {
      return;
    }

    // This shows the notification using the local plugin.
    _showAndroidNotification(notification, android, message);
  }

  // This logs when a notification is opened from background state.
  void _handleNotificationOpenFromBackground(RemoteMessage message) {
    // This logs the message id for debugging.
    debugPrint('Notification opened from background: ${message.messageId}');
  }

  // This displays a notification using Android channel details.
  Future<void> _showAndroidNotification(
    RemoteNotification notification,
    AndroidNotification android,
    RemoteMessage message,
  ) async {
    // This builds the Android-specific notification details.
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      // This uses our high-importance channel id.
      kHighImportanceChannel.id,
      // This uses our high-importance channel name.
      kHighImportanceChannel.name,
      // This uses our high-importance channel description.
      channelDescription: kHighImportanceChannel.description,
      // This makes the notification appear urgent.
      importance: Importance.high,
      // This makes the notification show at the top of the tray.
      priority: Priority.high,
      // This allows sound for the notification.
      playSound: true,
      // This uses the small icon from the FCM message.
      icon: android.smallIcon,
    );

    // This wraps the platform details into a single object.
    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // This shows the notification on the device.
    await _localNotifications.show(
      // This is a unique id for the notification.
      notification.hashCode,
      // This is the notification title text.
      notification.title,
      // This is the notification body text.
      notification.body,
      // This passes the full details object to the plugin.
      details,
      // This attaches raw data for tap handling.
      payload: message.data.toString(),
    );
  }
}
