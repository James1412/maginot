import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maginot/view_models/is_vertical_vm.dart';
import 'package:provider/provider.dart';
import '../data/heatmap_color.dart';

class HeatMapContainer extends StatelessWidget {
  final DateTime date;
  final double? size;
  final double? fontSize;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final EdgeInsets? margin;
  final bool? showText;
  final Function(DateTime dateTime)? onClick;
  final String? dday;

  const HeatMapContainer({
    super.key,
    required this.date,
    this.margin,
    this.size,
    this.fontSize,
    this.borderRadius,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.onClick,
    this.showText,
    required this.dday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.all(2),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? HeatMapColor.defaultColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 5)),
            ),
            child: (showText ?? true)
                ? (DateTime(date.year, date.month, date.day) ==
                        DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day))
                    ? (dday != null)
                        ? (context.watch<IsVerticalViewModel>().isVertical)
                            ? Transform(
                                transform: Matrix4.rotationY(pi),
                                alignment: Alignment.center,
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Text(
                                    dday!,
                                    style: TextStyle(
                                      color: textColor ??
                                          Color.fromARGB(255, 94, 91, 91),
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                dday!,
                                style: TextStyle(
                                  color: textColor ??
                                      Color.fromARGB(255, 94, 91, 91),
                                  fontSize: fontSize,
                                ),
                              )
                        : null
                    : null
                : null,
          ),
        ),
        onTap: () {
          onClick != null ? onClick!(date) : null;
        },
      ),
    );
  }
}
