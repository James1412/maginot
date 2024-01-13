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
        scaffoldBackgroundColor: Colors.grey.shade300,
      ),
      home: const HomeScreen(),
    );
  }
}
