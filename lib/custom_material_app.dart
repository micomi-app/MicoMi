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
          onPrimary: Colors.white,
          secondary: const Color(0xffc5e0e8),
          onSecondary: Colors.black,
          tertiary: Color.lerp(Colors.black, Colors.white, 0.9),
          onTertiary: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xff333333),
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
          onPrimary: Colors.white,
          secondary: Color.lerp(const Color(0xff4e7682), Colors.black, 0.5)!,
          onSecondary: Colors.white,
          tertiary: Color.lerp(Colors.white, Colors.black, 0.9),
          onTertiary: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
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
