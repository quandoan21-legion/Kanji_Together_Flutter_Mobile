// This file builds the MaterialApp widget.
// MaterialApp provides theming, navigation, and default visuals.

// This brings in Flutter's Material widgets.
import 'package:flutter/material.dart';

// This widget chooses the home screen for the app.
import 'app_home.dart';

// This widget owns the MaterialApp configuration.
class AppMaterial extends StatelessWidget {
  // This is a simple constructor with a key for Flutter.
  const AppMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the top-level widget for a Material-style app.
    return const MaterialApp(
      // This hides the debug banner in the top right corner.
      debugShowCheckedModeBanner: false,

      // This chooses the first screen the user sees.
      home: AppHome(),
    );
  }
}
