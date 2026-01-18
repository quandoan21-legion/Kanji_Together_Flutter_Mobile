// This file runs the startup steps before the UI appears.
// It keeps the main() function small and easy to scan.

// This gives access to Firebase initialization.
import 'package:firebase_core/firebase_core.dart';
// This lets us register a background message handler.
import 'package:firebase_messaging/firebase_messaging.dart';
// This gives access to core Flutter setup functions like runApp.
import 'package:flutter/widgets.dart';

// This handles Firebase background messages in a separate file.
import '../services/notification_background_handler.dart';
// This sets up local and push notification behavior.
import '../services/notification_initializer.dart';
// This is the root widget for the app UI.
import 'app_root.dart';

// This class exists to group startup work into small, named steps.
class AppBootstrap {
  // This runs every startup step in order.
  Future<void> run() async {
    // This makes sure Flutter engine bindings are ready.
    _ensureFlutterBinding();

    // This connects the app to Firebase before using Firebase APIs.
    await _initializeFirebase();

    // This wires the background message handler for notifications.
    _registerBackgroundHandler();

    // This prepares notification permissions and listeners.
    await _initializeNotifications();

    // This shows the UI after all setup work is done.
    _runApp();
  }

  // This is required before using platform channels.
  void _ensureFlutterBinding() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // This is a tiny wrapper around Firebase.initializeApp().
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // This connects Firebase to the background handler function.
  void _registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  }

  // This creates and runs the notification initializer.
  Future<void> _initializeNotifications() async {
    // This object hides notification setup details.
    final NotificationInitializer initializer = NotificationInitializer();

    // This runs the full notification setup process.
    await initializer.initialize();
  }

  // This starts the Flutter UI tree.
  void _runApp() {
    runApp(const AppRoot());
  }
}
