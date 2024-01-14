import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';

final _verticalBox = Hive.box(isverticalBoxName);

class IsVerticalRepository {
  Future<void> setIsVertical(bool value) async {
    _verticalBox.put(isverticalBoxName, value);
  }

  bool isVertical() {
    return _verticalBox.get(isverticalBoxName) ?? false;
  }
}
