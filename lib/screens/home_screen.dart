import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maginot/components/heat_map.dart';
import 'package:maginot/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color selectedColor = Colors.red.shade400;
  bool isChecked = false;

  void onSettingsTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: onSettingsTap,
                child: const FaIcon(FontAwesomeIcons.gear),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 100,
            ),
            const HeatMapWidget(),
            ListTile(
              title: const Text("Finish Homework"),
              leading: Checkbox(
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                    if (isChecked) {
                      selectedColor = Colors.yellow;
                    } else {
                      selectedColor = Colors.red.shade400;
                    }
                  });
                },
                value: isChecked,
              ),
              trailing: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.green,
          backgroundColor: Colors.green.shade300,
          foregroundColor: Colors.white,
          onPressed: () {},
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
