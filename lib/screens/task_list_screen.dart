import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/components/maginot_dialog.dart';
import 'package:maginot/components/yearly_calendar_heat_map.dart';
import 'package:maginot/screens/settings.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:maginot/view_models/is_vertical_vm.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  final taskBox;
  final taskdb;
  const TaskListScreen(
      {super.key, required this.taskBox, required this.taskdb});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.taskBox.get(taskBoxName) == null) {
      widget.taskdb.createInitialData();
    } else {
      widget.taskdb.loadData();
    }
    widget.taskdb.updateDataBase();
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
      widget.taskdb.deadlines.add([textAndDates[1], 2, textAndDates[0], false]);
      setState(() {});
    }
    widget.taskdb.updateDataBase();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onListTileTap(int index) {
    setState(() {
      widget.taskdb.deadlines[index][3] = !widget.taskdb.deadlines[index][3];
      if (widget.taskdb.deadlines[index][3]) {
        widget.taskdb.deadlines[index][1] = 3;
      } else {
        widget.taskdb.deadlines[index][1] = 2;
      }
    });
    widget.taskdb.updateDataBase();
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
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.taskdb.deadlines.length,
          itemBuilder: (context, index) => InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () => onListTileTap(index),
            child: Slidable(
              key: const ValueKey(0),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                dismissible: DismissiblePane(onDismissed: () {
                  setState(() {
                    widget.taskdb.deadlines.removeAt(index);
                  });
                  widget.taskdb.updateDataBase();
                }),
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(5),
                    backgroundColor: Colors.red,
                    onPressed: (context) {
                      setState(() {
                        widget.taskdb.deadlines.removeAt(index);
                      });
                      widget.taskdb.updateDataBase();
                    },
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: ListTile(
                shape: Border(
                    bottom:
                        BorderSide(color: Colors.grey.shade400, width: 0.4)),
                title: Text(widget.taskdb.deadlines[index][2]),
                subtitle: Text(
                    widget.taskdb.deadlines[index][0].toString().split(" ")[0]),
                leading: Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) => onListTileTap(index),
                  value: widget.taskdb.deadlines[index][3],
                ),
                trailing: const Icon(Icons.chevron_left),
              ),
            ),
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(microseconds: 100),
          opacity: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 1 : 0,
          child: FloatingActionButton(
            heroTag: "List",
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
      ),
    );
  }
}