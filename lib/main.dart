// This file starts the app.
// We keep it tiny so beginners can find the starting point quickly.

// This import brings in the app bootstrap helper.
import 'app/app_bootstrap.dart';

// This is the program entry point that Flutter runs first.
Future<void> main() async {
  // This object knows how to set up services before the UI shows.
  final AppBootstrap bootstrap = AppBootstrap();

  // This runs all startup steps in a clear, ordered way.
  await bootstrap.run();
}
