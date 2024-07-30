import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixthsense/providers/settings_provider.dart';
import 'package:sixthsense/utils/routes.dart';
import 'package:sixthsense/utils/theme.dart';

// This is the main application widget
// It sets up the MaterialApp with the routes and theme based on the user's settings
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // The build method for the widget
  // It watches the settingsProvider for changes to the themeMode and updates the theme accordingly
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current themeMode from the settingsProvider
    final themeMode = ref.watch(settingsProvider);

    // Return the MaterialApp with the appropriate theme and routes
    return MaterialApp(
      title: 'Sixth Sense',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routesConfig,
      theme: TAppTheme.lightThemeData,
      darkTheme: TAppTheme.darkThemeData,
      themeMode: themeMode.currentTheme,
    );
  }
}
