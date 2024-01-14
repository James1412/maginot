import 'dart:math';

import 'package:flutter/material.dart';
import '../util/date_util.dart';

class HeatMapWeekText extends StatelessWidget {
  /// The margin value for correctly space between labels.
  final EdgeInsets? margin;

  /// The double value of label's font size.
  final double? fontSize;

  /// The double value of every block's size to fit the height.
  final double? size;

  /// The color value of every font's color.
  final Color? fontColor;
  final bool isVertical;

  const HeatMapWeekText({
    super.key,
    this.margin,
    this.fontSize,
    this.size,
    this.fontColor,
    required this.isVertical,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (String label in DateUtil.WEEK_LABEL)
          Container(
            height: size ?? 20,
            margin: margin ?? const EdgeInsets.all(2.0),
            child: isVertical
                ? Transform.translate(
                    offset: label == "Sun"
                        ? const Offset(0, 0)
                        : label == "Mon"
                            ? const Offset(0, -1)
                            : label == "Tue"
                                ? const Offset(0, 1)
                                : label == "Wed"
                                    ? const Offset(0, -1)
                                    : label == "Thu"
                                        ? const Offset(0, 0)
                                        : label == "Fri"
                                            ? const Offset(0, 4)
                                            : label == "Sat"
                                                ? const Offset(0, 1.5)
                                                : Offset.zero,
                    child: Transform(
                      transform: Matrix4.rotationX(pi),
                      alignment: Alignment.center,
                      child: RotatedBox(
                        quarterTurns: isVertical ? 3 : 0,
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: fontSize ?? 12,
                            color: fontColor,
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize ?? 12,
                      color: fontColor,
                    ),
                  ),
          ),
      ],
    );
  }
}
