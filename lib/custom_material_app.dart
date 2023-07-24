import 'package:flutter/material.dart';

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
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xff4e7682),
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      themeMode: ThemeMode.system,
      home: home,
    );
  }
}