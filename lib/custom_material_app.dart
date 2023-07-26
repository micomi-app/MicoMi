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
        colorScheme: ColorScheme.light(
          primary: const Color(0xff8daeb8),
          secondary: const Color(0xff8daeb8).withOpacity(0.5),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xff4e7682),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xff4e7682),
          secondary: const Color(0xff4e7682).withOpacity(0.5),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
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
