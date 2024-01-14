import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/repos/color_config_repo.dart';
import 'package:maginot/screens/home_screen.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(colorBoxName);
  final repository = ColorConfigRepository();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ColorsConfigViewModel(repository)),
      ],
      child: const MaginotApp(),
    ),
  );
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
