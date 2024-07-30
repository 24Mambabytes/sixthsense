import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:sixthsense/views/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  // Builds the splash screen widget.
  //
  // This function returns an [AnimatedSplashScreen] widget that displays a splash
  // screen with the text "Sixth Sense" and "Powered by Flutter" centered on the screen.
  // The splash screen remains on screen for 2000 milliseconds.

  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        nextScreen: Home(),
        duration: 2000,
        function: () async {},
        splash: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sixth Sense',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Text(
              'Powered by Flutter',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ));
  }
}
