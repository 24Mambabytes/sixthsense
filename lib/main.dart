import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

List<CameraDescription> cameras = [];

// The main entry point for the application.
Future<void> main() async {
// Initializes the Flutter binding, sets the preferred orientation to portrait
// up only, fetches the list of available cameras, and runs the application.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    // Throws a [CameraException] if camera access is denied or an error occurs
    // while fetching available cameras.
    switch (e.code) {
      case 'CameraAccessDenied':
        debugPrint('Camera access denied!.');
        break;
      default:
        debugPrint('An error occurred while fetching available cameras!: $e.');
        break;
    }
  }
  // entry point for the application
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
