import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/components/maginot_dialog.dart';
import 'package:maginot/components/yearly_calendar_heat_map.dart';
import 'package:maginot/databases/task_database.dart';
import 'package:maginot/screens/settings.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:maginot/view_models/is_vertical_vm.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskBox = Hive.box(taskBoxName);
  final taskdb = TaskDatabase();

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

  @override
  void initState() {
    super.initState();
    if (_taskBox.get(taskBoxName) == null) {
      taskdb.createInitialData();
    } else {
      taskdb.loadData();
    }
    taskdb.updateDataBase();
  }

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
      taskdb.deadlines.add([textAndDates[1], 2, textAndDates[0], false]);
      setState(() {});
    }
    taskdb.updateDataBase();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onListTileTap(int index) {
    setState(() {
      taskdb.deadlines[index][3] = !taskdb.deadlines[index][3];
      if (taskdb.deadlines[index][3]) {
        taskdb.deadlines[index][1] = 3;
      } else {
        taskdb.deadlines[index][1] = 2;
      }
    });
    taskdb.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  color: Theme.of(context).scaffoldBackgroundColor,
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
                              deadlines: taskdb.deadlines,
                            ),
                          ),
                        )
                      : HeatMapWidget(
                          deadlines: taskdb.deadlines,
                        ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: taskdb.deadlines.length,
                itemBuilder: (context, index) => InkWell(
                  splashFactory: InkRipple.splashFactory,
                  onTap: () => onListTileTap(index),
                  child: Slidable(
                    key: const ValueKey(0),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        setState(() {
                          taskdb.deadlines.removeAt(index);
                        });
                        taskdb.updateDataBase();
                      }),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(5),
                          backgroundColor: Colors.red,
                          onPressed: (context) {
                            setState(() {
                              taskdb.deadlines.removeAt(index);
                            });
                            taskdb.updateDataBase();
                          },
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: ListTile(
                      shape: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade400, width: 0.4)),
                      title: Text(taskdb.deadlines[index][2]),
                      subtitle: Text(
                          taskdb.deadlines[index][0].toString().split(" ")[0]),
                      leading: Checkbox(
                        activeColor: Colors.green,
                        onChanged: (value) => onListTileTap(index),
                        value: taskdb.deadlines[index][3],
                      ),
                      trailing: const Icon(Icons.chevron_left),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(microseconds: 100),
          opacity: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 1 : 0,
          child: FloatingActionButton(
            splashColor:
                Color(context.watch<ColorsConfigViewModel>().pastdayColor),
            backgroundColor:
                Color(context.watch<ColorsConfigViewModel>().pastdayColor)
                    .withOpacity(0.7),
            foregroundColor: Colors.white,
            onPressed: onAddDeadlinePressed,
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
          ],
        ),
      ),
    );
  }
}
