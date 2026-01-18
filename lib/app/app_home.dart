// This file defines the first screen widget for the app.
// It keeps the home screen choice in a tiny, readable place.

// This brings in the base Flutter widget types.
import 'package:flutter/widgets.dart';

// This is the existing main layout screen for the app.
import '../screens/main_layout.dart';

// This widget points MaterialApp.home to the actual screen.
class AppHome extends StatelessWidget {
  // This is a simple constructor with a key for Flutter.
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    // This returns the existing main layout screen.
    return const MainLayout();
  }
}
