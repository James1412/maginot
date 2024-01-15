import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';

final _verticalBox = Hive.box(isverticalBoxName);
final _showddayBox = Hive.box(showDDayBoxName);

class IsVerticalRepository {
  Future<void> setIsVertical(bool value) async {
    _verticalBox.put(isverticalBoxName, value);
  }

  bool isVertical() {
    return _verticalBox.get(isverticalBoxName) ?? true;
  }
}

class ShowDDayRepository {
  Future<void> setShowDDay(bool value) async {
    _showddayBox.put(showDDayBoxName, value);
  }

  bool isShowDDay() {
    return _showddayBox.get(showDDayBoxName) ?? false;
  }
}
