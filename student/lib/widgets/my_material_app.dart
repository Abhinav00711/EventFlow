import 'package:flutter/material.dart';

class MyMaterialApp extends StatelessWidget {
  final Widget home;
  const MyMaterialApp(this.home, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color(0xFF640D14),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        platform: TargetPlatform.android,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF800E13),
        ),
      ),
      home: home,
    );
  }
}
