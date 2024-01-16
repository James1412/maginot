import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/components/maginot_dialog.dart';
import 'package:maginot/databases/task_database.dart';
import 'package:maginot/screens/home_screen.dart';
import 'package:maginot/screens/task_list_screen.dart';
import 'package:maginot/services/notification_id_counter.dart';
import 'package:maginot/services/notification_service.dart';
import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int selectedIndex = 0;
  final _taskBox = Hive.box(taskBoxName);
  final taskdb = TaskDatabase();
  final idBox = Hive.box(idBoxName);
  final todayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<void> onAddDeadlinePressed(
      TextEditingController controller, BuildContext context) async {
    List? textAndDates = await showDialog(
      context: context,
      builder: (context) => MaginotDialog(
        controller: controller,
      ),
    );
    if (textAndDates != null) {
      if (!mounted) return;
      context.read<NotificationIDCounter>().incrementIdByTwo();
      // Add to the database and sort it by Dates
      taskdb.deadlines
          .add([textAndDates[1], 2, textAndDates[0], false, idBox.get('id')]);
      taskdb.deadlines.sort((a, b) => a[0].compareTo(b[0]));
      taskdb.updateDataBase();

      await addNotification(textAndDates, idBox.get('id'));

      setState(() {});
    }
  }

  Future<void> addNotification(textAndDates, id) async {
    DateTime deadlineDate = textAndDates[1];
    // Add 8 hours so notifications can go off at 8 am
    DateTime weekBeforeDate = deadlineDate
        .subtract(const Duration(days: 7))
        .add(const Duration(hours: 8));
    DateTime threeDaysBeforeDate =
        deadlineDate.subtract(Duration(days: 3)).add(Duration(hours: 8));
    DateTime dayBeforeDate = deadlineDate
        .subtract(const Duration(days: 1))
        .add(const Duration(hours: 8));

    if (DateTime.now().isBefore(weekBeforeDate)) {
      print(weekBeforeDate);
      print(id);
      await NotificationService().scheduleNotification(
          id: id,
          title: "${textAndDates[0]} is due in a week!",
          body: "Check the deadline",
          scheduledNotificationDateTime: weekBeforeDate);
    }
    if (DateTime.now().isBefore(threeDaysBeforeDate)) {
      print(threeDaysBeforeDate);
      print(id + 1);
      await NotificationService().scheduleNotification(
          id: id + 1,
          title: "${textAndDates[0]} is due in three days!",
          body: "Check the deadline",
          scheduledNotificationDateTime: threeDaysBeforeDate);
    }
    if (DateTime.now().isBefore(dayBeforeDate)) {
      print(dayBeforeDate);
      print(id * -1);
      await NotificationService().scheduleNotification(
          id: id * -1,
          title: "${textAndDates[0]} is due tomorrow!!",
          body: "Check the deadline",
          scheduledNotificationDateTime: dayBeforeDate);
    }
  }

  Future<void> onDeleteTask(int index, BuildContext context) async {
    await NotificationService()
        .cancelScheduledNotification(taskdb.deadlines[index][4]);
    await NotificationService()
        .cancelScheduledNotification(taskdb.deadlines[index][4] * -1);
    setState(() {
      taskdb.deadlines.removeAt(index);
    });
    taskdb.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: selectedIndex != 0,
            child: HomeScreen(
              onAdd: onAddDeadlinePressed,
              taskBox: _taskBox,
              taskdb: taskdb,
            ),
          ),
          Offstage(
            offstage: selectedIndex != 1,
            child: TaskListScreen(
              onAddNotification: addNotification,
              onDeleteTask: onDeleteTask,
              onAdd: onAddDeadlinePressed,
              taskBox: _taskBox,
              taskdb: taskdb,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
