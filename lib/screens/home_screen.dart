import 'package:flutter/material.dart';
import 'package:maginot/components/heat_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: const Scaffold(
        body: Center(child: HeatMapWidget()),
      ),
    );
  }
}
