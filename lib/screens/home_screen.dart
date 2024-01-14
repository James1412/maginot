import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maginot/components/maginot_dialog.dart';
import 'package:maginot/components/yearly_calendar_heat_map.dart';
import 'package:maginot/screens/settings.dart';
import 'package:maginot/view_models/is_vertical_vm.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
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
    _scrollController.dispose();
    super.dispose();
  }

  void onListTileTap(int index) {
    setState(() {
      deadlines[index][3] = !deadlines[index][3];
      if (deadlines[index][3]) {
        deadlines[index][1] = 3;
      } else {
        deadlines[index][1] = 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
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
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: context.watch<IsVerticalViewModel>().isVertical
                      ? 580
                      : 450,
                  color: Colors.grey.shade300,
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Tasks",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: context.watch<IsVerticalViewModel>().isVertical
                      ? 550
                      : null,
                  child: context.watch<IsVerticalViewModel>().isVertical
                      ? Scrollbar(
                          thickness: 5,
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: HeatMapWidget(
                              deadlines: deadlines,
                            ),
                          ),
                        )
                      : HeatMapWidget(
                          deadlines: deadlines,
                        ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: deadlines.length,
                itemBuilder: (context, index) => InkWell(
                  splashFactory: InkRipple.splashFactory,
                  onTap: () => onListTileTap(index),
                  child: Slidable(
                    key: const ValueKey(0),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        setState(() {
                          deadlines.removeAt(index);
                        });
                      }),
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
                      shape: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade400, width: 0.4)),
                      title: Text(deadlines[index][2]),
                      subtitle:
                          Text(deadlines[index][0].toString().split(" ")[0]),
                      leading: Checkbox(
                        activeColor: Colors.green,
                        onChanged: (value) => onListTileTap(index),
                        value: deadlines[index][3],
                      ),
                      trailing: const Icon(Icons.chevron_left),
                    ),
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
