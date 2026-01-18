// This file holds the background notification handler.
// Firebase requires this handler to be a top-level function.

// This import allows Firebase setup inside the handler.
import 'package:firebase_core/firebase_core.dart';
// This gives access to RemoteMessage types.
import 'package:firebase_messaging/firebase_messaging.dart';
// This gives access to debugPrint for simple logging.
import 'package:flutter/foundation.dart';

// This tells Flutter this function can be called by the VM in the background.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // This makes sure Firebase is ready before using it in background.
  await Firebase.initializeApp();

  // This logs which message was received for debugging.
  debugPrint('Background message received: ${message.messageId}');
}
