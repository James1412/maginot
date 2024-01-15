import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/databases/task_database.dart';
import 'package:maginot/screens/home_screen.dart';
import 'package:maginot/screens/task_list_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int selectedIndex = 0;
  final _taskBox = Hive.box(taskBoxName);
  final taskdb = TaskDatabase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: selectedIndex != 0,
            child: HomeScreen(
              taskBox: _taskBox,
              taskdb: taskdb,
            ),
          ),
          Offstage(
            offstage: selectedIndex != 1,
            child: TaskListScreen(
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
