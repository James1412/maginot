import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';

class TaskDatabase {
  List deadlines = [[]];

  final _taskBox = Hive.box(taskBoxName);

  void createInitialData() {
    deadlines = [
      // DateTime, colorset, text, isFinished, id
      [
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(const Duration(days: 5))
              .toUtc()
              .day,
        ),
        2,
        "Do homework",
        false,
        0,
      ],
    ];
  }

  void loadData() {
    deadlines = _taskBox.get(taskBoxName);
  }

  void updateDataBase() {
    _taskBox.put(taskBoxName, deadlines);
  }
}
