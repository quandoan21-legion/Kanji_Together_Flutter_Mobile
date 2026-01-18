// This file stores simple notification constants in one place.
// Keeping constants here makes other files easier to read.

// This import provides the Android channel type.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This channel is used for important notifications on Android.
const AndroidNotificationChannel kHighImportanceChannel =
    AndroidNotificationChannel(
  // This is the unique channel id used by Android.
  'high_importance_channel',

  // This is the channel name shown in Android settings.
  'High Importance Notifications',

  // This describes what the channel is for.
  description: 'Used for important notifications.',

  // This makes the notification show prominently.
  importance: Importance.high,

  // This enables sound for the channel.
  playSound: true,
);
