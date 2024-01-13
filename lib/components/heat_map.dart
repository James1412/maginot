import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapWidget extends StatefulWidget {
  const HeatMapWidget({super.key});

  @override
  State<HeatMapWidget> createState() => _HeatMapWidgetState();
}

class _HeatMapWidgetState extends State<HeatMapWidget> {
  Map<DateTime, int> datasets = {
    DateTime(2024, 1, 13): 1,
    DateTime(2024, 1, 12): 9,
    DateTime(2024, 1, 10): 4,
    DateTime(2024, 1, 9): 2,
    DateTime(2024, 1, 15): 13,
  };

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      datasets: datasets,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 10)),
      colorsets: {
        1: Colors.green.shade100,
        3: Colors.green.shade200,
        5: Colors.green.shade300,
        7: Colors.green.shade400,
        9: Colors.green.shade500,
        11: Colors.green.shade600,
        13: Colors.green.shade700,
        15: Colors.green.shade800,
        17: Colors.green.shade900,
      },
      onClick: (value) {
        int currentValue = datasets[value] ?? 0;
        datasets[value] = currentValue + 1;
        setState(() {});
      },
      size: 40,
    );
  }
}
