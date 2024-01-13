import 'package:flutter/material.dart';

import '../heat_map/data/heatmap_color_mode.dart';
import '../heat_map/heatmap.dart';

class HeatMapWidget extends StatefulWidget {
  const HeatMapWidget({super.key});

  @override
  State<HeatMapWidget> createState() => _HeatMapWidgetState();
}

class _HeatMapWidgetState extends State<HeatMapWidget> {
  final int currentYear = DateTime.now().year;
  final deadline = DateTime(DateTime.now().year, 1, 20);
  final ScrollController _controller = ScrollController(
      initialScrollOffset:
          (DateTime.now().difference(DateTime(2024, 1, 1)).inDays / 7) /
              52 *
              2557);

  @override
  Widget build(BuildContext context) {
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
                  DateTime.utc(2024, 10, 31)
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

          deadline: 2,
        },
        colorsets: {
          1: Colors.green.shade400,
          2: Colors.red.shade400,
          3: Colors.yellow,
        },
        size: 50,
        showColorTip: false,
        onClick: (value) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                child: Text(
                  "Date: ${value.toString().split(" ")[0]}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
