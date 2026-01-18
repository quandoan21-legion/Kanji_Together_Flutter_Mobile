// This file defines the very top widget of the app.
// It exists so the app root is easy to find and read.

// This brings in the basic Flutter widget types.
import 'package:flutter/material.dart';

// This widget builds the MaterialApp configuration.
import 'app_material.dart';

// This widget is the root of the widget tree.
class AppRoot extends StatelessWidget {
  // This is a simple constructor with a key for Flutter.
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget simply returns the MaterialApp wrapper.
    return const AppMaterial();
  }
}
