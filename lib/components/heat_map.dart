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
  final ScrollController _controller = ScrollController(
    initialScrollOffset:
        (DateTime.now().difference(DateTime(2024, 1, 1)).inDays / 7) /
            52 *
            1932,
  );
  final deadline = DateTime(DateTime.now().year, 1, 20);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      controller: _controller,
      startDate: DateTime(currentYear, 1, 1).add(const Duration(days: 1)),
      endDate: DateTime(currentYear, 12, 31),
      scrollable: true,
      colorMode: ColorMode.color,
      datasets: {
        deadline: 2,
        for (var i = 0;
            i < DateTime.now().difference(DateTime(currentYear, 1, 1)).inDays;
            i++)
          DateTime(currentYear, 1, 1).add(Duration(days: i)): 1,
      },
      colorsets: {
        1: Colors.green.shade400,
        2: Colors.red.shade400,
      },
      size: 40,
      showColorTip: false,
      onClick: (value) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value.toString().split(" ")[0],
            ),
          ),
        );
      },
    );
  }
}
