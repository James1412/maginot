import 'package:flutter/material.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:provider/provider.dart';

import '../heat_map/data/heatmap_color_mode.dart';
import '../heat_map/heatmap.dart';

class HeatMapWidget extends StatefulWidget {
  final List<List<dynamic>> deadline;
  const HeatMapWidget({super.key, required this.deadline});

  @override
  State<HeatMapWidget> createState() => _HeatMapWidgetState();
}

class _HeatMapWidgetState extends State<HeatMapWidget> {
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;
  final int currentDay = DateTime.now().day;

  final ScrollController _controller = ScrollController(
      initialScrollOffset: (DateTime.utc(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day)
                  .difference(DateTime(2024, 1, 1))
                  .inDays /
              7) /
          52 *
          2641);

  @override
  void initState() {
    _controller.addListener(() {
      print(_controller.offset);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List deadlineOnDate = [];

  @override
  Widget build(BuildContext context) {
    // Handle Multiple Events On The Same Date
    Map<DateTime, bool> resultMap = {};

    for (var data in widget.deadline) {
      DateTime date = data[0];
      bool hasFalseValue =
          resultMap.containsKey(date) ? resultMap[date]! : false;

      if (data.length > 3 && data[3] == false) {
        hasFalseValue = true;
      }

      resultMap[date] = hasFalseValue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: HeatMap(
        controller: _controller,
        startDate: DateTime(currentYear, 1, 1),
        endDate: DateTime(currentYear, 12, 31),
        scrollable: true,
        colorMode: ColorMode.color,
        datasets: {
          // Check a few previous December days as they are not colored
          for (var i = 0; i < 7; i++)
            DateTime(currentYear - 1, 12, 25).add(Duration(days: i)): 1,

          // Color all previous days in current year
          for (var dayNum = 0;
              dayNum <=
                  DateTime.utc(currentYear, currentMonth, currentDay)
                      .difference(DateTime.utc(currentYear - 1, 12, 31))
                      .inDays;
              dayNum++)
            DateTime(
                DateTime(currentYear - 1, 12, 31)
                    .add(Duration(days: dayNum))
                    .year,
                DateTime(currentYear - 1, 12, 31)
                    .add(Duration(days: dayNum))
                    .month,
                DateTime(currentYear - 1, 12, 31)
                    .add(Duration(days: dayNum))
                    .day): 1,

          // Add datasets from the input
          for (List deadline in widget.deadline)
            deadline[0].add(const Duration(days: 0)):
                resultMap[deadline[0]] == false ? 3 : 2,
        },
        colorsets: {
          1: Color(context.watch<ColorsConfigViewModel>().pastdayColor),
          2: Color(context.watch<ColorsConfigViewModel>().incompleteColor),
          3: Color(context.watch<ColorsConfigViewModel>().completeColor),
        },
        size: 53,
        showColorTip: false,
        onClick: (value) {
          deadlineOnDate.clear();
          for (List list in widget.deadline) {
            if (list[0] == value) {
              if (!deadlineOnDate.contains(list)) {
                deadlineOnDate.add(list[2]);
                setState(() {});
              }
            }
          }
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            dateSnackBar(value),
          );
        },
      ),
    );
  }

  SnackBar dateSnackBar(DateTime value) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value.toString().split(" ")[0],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            for (String item in deadlineOnDate)
              Text(
                item,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
