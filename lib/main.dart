import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

List<CameraDescription> cameras = [];

// The main entry point for the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initializes the Flutter binding
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]); // sets the preferred orientation to portrait up only.

  try {
    cameras = await availableCameras(); // fetch list of available cameras
  } on CameraException catch (e) {
    // catch any exceptions associated with fetching the cameras
    switch (e.code) {
      case 'CameraAccessDenied':
        debugPrint('Camera access denied!.');
        break;
      default:
        debugPrint('An error occurred while fetching available cameras!: $e.');
        break;
    }
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
