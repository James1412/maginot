import 'package:flutter/material.dart';
import 'package:maginot/screens/home_screen.dart';

void main() {
  runApp(const MaginotApp());
}

class MaginotApp extends StatelessWidget {
  const MaginotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade300,
          shadowColor: Colors.grey.shade300,
          surfaceTintColor: Colors.grey.shade300,
        ),
        scaffoldBackgroundColor: Colors.grey.shade300,
        dialogBackgroundColor: Colors.grey.shade100,
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey.shade100,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
