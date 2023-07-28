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
          onPrimary: Colors.white,
          secondary: Color(0xffc5e0e8),
          onSecondary: Colors.black,
          background: Colors.white,
          onBackground: Color(0xff333333),
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
