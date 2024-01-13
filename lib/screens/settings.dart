import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color inCompleteColor = Colors.red.shade400;
  Color completedColor = Colors.green.shade700;
  Color finishedDayColor = Colors.green.shade300;

  Future<void> onColorChangeTap(String text) async {
    if (text == "complete") {
      completedColor = await showColorPickerDialog(
        context,
        completedColor,
      );
    } else if (text == "finishedDay") {
      finishedDayColor = await showColorPickerDialog(
        context,
        finishedDayColor,
      );
    } else {
      inCompleteColor = await showColorPickerDialog(
        context,
        inCompleteColor,
      );
    }
    setState(() {});
  }

  void changeToDefaultColors() {
    inCompleteColor = Colors.red.shade400;
    completedColor = Colors.green.shade700;
    finishedDayColor = Colors.green.shade300;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  onTap: () => onColorChangeTap('incomplete'),
                  title: const Text("Change due date color"),
                  trailing: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: inCompleteColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => onColorChangeTap('complete'),
                  title: const Text("Change finished task color"),
                  trailing: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: completedColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => onColorChangeTap('finishedDay'),
                  title: const Text("Change finished day color"),
                  trailing: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: finishedDayColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                ListTile(
                  onTap: changeToDefaultColors,
                  title: const Text("Change to default colors"),
                ),
              ],
            ),
            const Column(
              children: [
                AboutListTile(
                  applicationName: "Maginot",
                  child: Text("About"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
