import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:maginot/view_models/is_vertical_vm.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> onColorChangeTap(String text) async {
    var selectedColor = Colors.white;
    if (text == complete) {
      selectedColor = await showColorPickerDialog(
        context,
        Color(context.read<ColorsConfigViewModel>().completeColor),
      );
    } else if (text == pastday) {
      selectedColor = await showColorPickerDialog(
          context, Color(context.read<ColorsConfigViewModel>().pastdayColor));
    } else {
      selectedColor = await showColorPickerDialog(context,
          Color(context.read<ColorsConfigViewModel>().incompleteColor));
    }
    var returnValue = "0xff${selectedColor.hex}";
    if (!mounted) return;
    context
        .read<ColorsConfigViewModel>()
        .setColor(text, int.parse(returnValue));
    setState(() {});
  }

  void changeToDefaultColors() {
    context.read<ColorsConfigViewModel>().defaultColor();

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
                SwitchListTile(
                  activeColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  inactiveThumbColor: Colors.grey.shade600,
                  trackOutlineColor:
                      const MaterialStatePropertyAll(Colors.grey),
                  value: context.watch<IsVerticalViewModel>().isVertical,
                  onChanged: (value) =>
                      context.read<IsVerticalViewModel>().setVertical(value),
                  title: const Text("Vertical view"),
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  inactiveThumbColor: Colors.grey.shade600,
                  trackOutlineColor:
                      const MaterialStatePropertyAll(Colors.grey),
                  value: context.watch<ShowDDayViewModel>().isShowDDay,
                  onChanged: (value) =>
                      context.read<ShowDDayViewModel>().setIsDDay(value),
                  title: const Text("Show D-Day"),
                ),
                ListTile(
                  onTap: () => onColorChangeTap(incomplete),
                  title: const Text("Change due date color"),
                  trailing: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(context
                          .watch<ColorsConfigViewModel>()
                          .incompleteColor),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => onColorChangeTap(complete),
                  title: const Text("Change finished task color"),
                  trailing: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(
                          context.watch<ColorsConfigViewModel>().completeColor),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => onColorChangeTap(pastday),
                  title: const Text("Change past day color"),
                  trailing: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(
                          context.watch<ColorsConfigViewModel>().pastdayColor),
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
