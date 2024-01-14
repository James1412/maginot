import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';

final _colorBox = Hive.box(colorBoxName);

class ColorConfigRepository {
  Future<void> setColor(String name, int colorhex) async {
    _colorBox.put(name, colorhex);
  }

  int getCompleteColor() {
    return _colorBox.get(complete) ?? 0xFFFFEB3B;
  }

  int getIncompleteColor() {
    return _colorBox.get(incomplete) ?? 0xFFEF5350;
  }

  int getPastDayColor() {
    return _colorBox.get(pastday) ?? 0xFF66BB6A;
  }
}
