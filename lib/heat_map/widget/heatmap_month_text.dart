import 'dart:math';

import 'package:flutter/material.dart';
import '../util/date_util.dart';

class HeatMapMonthText extends StatelessWidget {
  /// List value of every sunday's month information.
  ///
  /// From 1: January to 12: December.
  final List<int>? firstDayInfos;

  /// The double value for space between labels.
  final double? size;

  /// The double value of font size.
  final double? fontSize;

  /// The color value of font color.
  final Color? fontColor;

  /// The margin value for correctly space between labels.
  final EdgeInsets? margin;

  final bool isVertical;

  const HeatMapMonthText({
    super.key,
    this.firstDayInfos,
    this.fontSize,
    this.fontColor,
    this.size,
    this.margin,
    required this.isVertical,
  });

  /// The list of every month labels and fitted space.
  List<Widget> _labels() {
    List<Widget> items = [];

    // Set true if previous week was the first day of the month.
    bool write = false;

    // Loop until check every given weeks.
    for (int label = 0; label < (firstDayInfos?.length ?? 0); label++) {
      // If given week is first week of given datesets or
      // first week of month, create labels
      if (label == 0 ||
          (label > 0 && firstDayInfos![label] != firstDayInfos![label - 1])) {
        write = true;

        // Add Text without width margin if first week is end of the month.
        // Otherwise, add Text with width margin.
        items.add(
          firstDayInfos!.length == 1 ||
                  (label == 0 &&
                      firstDayInfos![label] != firstDayInfos![label + 1])
              ? _renderText(DateUtil.SHORT_MONTH_LABEL[firstDayInfos![label]])
              : Container(
                  width: (((size ?? 20) + (margin?.right ?? 2)) * 2),
                  margin: EdgeInsets.only(
                      left: margin?.left ?? 2, right: margin?.right ?? 2),
                  child: _renderText(
                      DateUtil.SHORT_MONTH_LABEL[firstDayInfos![label]]),
                ),
        );
      } else if (write) {
        // If given week is the next week of labeled week.
        // do nothing.
        write = false;
      } else {
        // Else create empty box.
        items.add(Container(
          margin: EdgeInsets.only(
              left: margin?.left ?? 2, right: margin?.right ?? 2),
          width: size ?? 20,
        ));
      }
    }

    return items;
  }

  Widget _renderText(String text) {
    return Container(
      margin: isVertical ? const EdgeInsets.symmetric(horizontal: 15) : null,
      child: isVertical
          ? RotatedBox(
              quarterTurns: isVertical ? 1 : 0,
              child: Transform(
                transform: Matrix4.rotationX(pi),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: fontColor,
                    fontSize: fontSize,
                  ),
                ),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: fontColor,
                fontSize: fontSize,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels(),
    );
  }
}
