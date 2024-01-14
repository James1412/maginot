import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maginot/components/maginot_dialog.dart';
import 'package:maginot/components/yearly_calendar_heat_map.dart';
import 'package:maginot/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<List> deadlines = [
    [
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(const Duration(days: 5))
            .toUtc()
            .day,
      ),
      2,
      "Do homework",
      false,
    ],
  ];

  void onSettingsTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ));
  }

  Future<void> onAddDeadlinePressed() async {
    List? textAndDates = await showDialog(
      context: context,
      builder: (context) => MaginotDialog(
        controller: _controller,
      ),
    );
    if (textAndDates != null) {
      deadlines.add([textAndDates[1], 2, textAndDates[0], false]);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("M A G I N O T"),
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
            HeatMapWidget(
              deadline: deadlines,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deadlines.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    deadlines[index][3] = !deadlines[index][3];
                    if (deadlines[index][3]) {
                      deadlines[index][1] = 3;
                    } else {
                      deadlines[index][1] = 2;
                    }
                  });
                },
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(5),
                        backgroundColor: Colors.red,
                        onPressed: (context) {
                          setState(() {
                            deadlines.removeAt(index);
                          });
                        },
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(deadlines[index][2]),
                    leading: Checkbox(
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          deadlines[index][3] = !deadlines[index][3];
                          if (deadlines[index][3]) {
                            deadlines[index][1] = 3;
                          } else {
                            deadlines[index][1] = 2;
                          }
                        });
                      },
                      value: deadlines[index][3],
                    ),
                    trailing: const Icon(Icons.chevron_left),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.green,
          backgroundColor: Colors.green.shade300,
          foregroundColor: Colors.white,
          onPressed: onAddDeadlinePressed,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
