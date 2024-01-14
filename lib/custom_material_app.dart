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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffb8a78e),
          primary: const Color(0xffb8a78e),
          onPrimary: Colors.white,
          secondary: const Color(0xffb8a78e),
          onSecondary: Colors.black,
          tertiary: Color.lerp(Colors.black, Colors.white, 0.9),
          onTertiary: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xff333333),
          ),
        ),
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xff826b4e),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff826b4e),
          primary: const Color(0xff826b4e),
          onPrimary: Colors.white,
          secondary: Color.lerp(const Color(0xff826b4e), Colors.black, 0.5)!,
          onSecondary: Colors.white,
          tertiary: Color.lerp(Colors.white, Colors.black, 0.9),
          onTertiary: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', 'JP')],
      themeMode: ThemeMode.system,
      home: home,
    );
  }
}
