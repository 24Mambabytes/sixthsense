// this file contains the app theme
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();

  // light app theme
  static final ThemeData lightThemeData = ThemeData(
    brightness: Brightness.light,
    //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    fontFamily: 'MPLUSRounded1c',
  );

  // dark app theme
  static final ThemeData darkThemeData = ThemeData(
    brightness: Brightness.dark,
    //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    fontFamily: 'MPLUSRounded1c',
  );
}
