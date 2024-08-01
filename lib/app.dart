import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixthsense/providers/theme_provider.dart';
import 'package:sixthsense/utils/routes.dart';
import 'package:sixthsense/utils/theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    // Return the MaterialApp with the appropriate theme and routes
    return MaterialApp(
      title: 'Sixth Sense',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routesConfig,
      theme: TAppTheme.lightThemeData,
      darkTheme: TAppTheme.darkThemeData,
      themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
