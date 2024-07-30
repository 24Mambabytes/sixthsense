import 'package:sixthsense/views/help.dart';
import 'package:sixthsense/views/home.dart';
import 'package:sixthsense/views/settings.dart';
import 'package:sixthsense/views/splash.dart';

final routesConfig = {
  '/': (context) => const SplashScreen(), // home screen
  'home': (context) => Home(),
  'settings': (context) => const Settings(),
  'help': (context) => const Help(),
};
