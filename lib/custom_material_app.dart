import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CustomMaterialApp extends StatelessWidget {
  const CustomMaterialApp({super.key, required this.title, this.home});

  final String title;
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primaryColor: const Color(0xff8daeb8),
        colorScheme: const ColorScheme.light(
          primary: Color(0xff8daeb8),
          secondary: Color(0xff4e7682),
        ),
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xff4e7682),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff4e7682),
          secondary: Color(0xff8daeb8),
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', ''), Locale('en', '')],
      themeMode: ThemeMode.system,
      home: home,
    );
  }
}
