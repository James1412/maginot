import 'package:flutter/material.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:maginot/view_models/is_vertical_vm.dart';
import 'package:provider/provider.dart';

import '../heat_map/data/heatmap_color_mode.dart';
import '../heat_map/heatmap.dart';

class HeatMapWidget extends StatefulWidget {
  final List deadlines;
  const HeatMapWidget({super.key, required this.deadlines});

  @override
  State<HeatMapWidget> createState() => _HeatMapWidgetState();
}

class _HeatMapWidgetState extends State<HeatMapWidget> {
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;
  final int currentDay = DateTime.now().day;
  final DateTime lastDayinYear = DateTime(DateTime.now().year, 12, 31);

  final ScrollController _controller = ScrollController(
      initialScrollOffset: (DateTime.utc(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day)
                  .difference(DateTime(2024, 1, 1))
                  .inDays /
              7) /
          52 *
          2641);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List deadlinesOnDate = [];

  @override
  Widget build(BuildContext context) {
    Map<DateTime, bool> resultMap = {};
    var highestDate = DateTime(currentYear, currentMonth, currentDay);
    List<DateTime> sortedDates = [];
    if (widget.deadlines.isNotEmpty) {
      // Handle Multiple Events On The Same Date
      for (var data in widget.deadlines) {
        DateTime date = data[0];
        bool hasFalseValue =
            resultMap.containsKey(date) ? resultMap[date]! : false;

        if (data.length > 3 && data[3] == false) {
          hasFalseValue = true;
        }

        resultMap[date] = hasFalseValue;
      }

      // Sorted by date: highest -> lowest
      sortedDates = resultMap.keys.toList(growable: false)
        ..sort((a, b) => b.compareTo(a));
      highestDate = sortedDates.first;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: HeatMap(
        showText: true,
        isVertical: context.watch<IsVerticalViewModel>().isVertical,
        controller: _controller,
        startDate: DateTime(currentYear, 1, 1),
        endDate:
            highestDate.isAfter(lastDayinYear) ? highestDate : lastDayinYear,
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
          for (List deadline in widget.deadlines)
            deadline[0].add(const Duration(days: 0)):
                resultMap[deadline[0]] == false ? 3 : 2,
        },
        colorsets: {
          1: Color(context.watch<ColorsConfigViewModel>().pastdayColor),
          2: Color(context.watch<ColorsConfigViewModel>().incompleteColor),
          3: Color(context.watch<ColorsConfigViewModel>().completeColor),
        },
        size: context.watch<IsVerticalViewModel>().isVertical
            ? MediaQuery.of(context).size.width * 0.112
            : MediaQuery.of(context).size.height * 0.06,
        showColorTip: false,
        onClick: (value) {
          deadlinesOnDate.clear();
          for (List list in widget.deadlines) {
            if (list[0] == value) {
              if (!deadlinesOnDate.contains(list)) {
                deadlinesOnDate.add(list[2]);
                setState(() {});
              }
            }
          }
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            dateSnackBar(value),
          );
        },
        // show the closest dday that is not finished, or else, show none
        dday: resultMap.isEmpty
            ? null
            : resultMap[sortedDates.lastWhere(
                (element) => resultMap[element] == true,
                orElse: () => sortedDates[0],
              )]!
                ? "d-${sortedDates.lastWhere(
                      (element) => resultMap[element] == true,
                      orElse: () => sortedDates[0],
                    ).difference(DateTime.now()).inDays + 1}"
                : null,
      ),
    );
  }

  SnackBar dateSnackBar(DateTime value) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              color: Colors.grey.shade400,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value.toString().split(" ")[0],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
            for (String item in deadlinesOnDate)
              Text(
                "•$item",
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
