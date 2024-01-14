import 'package:flutter/material.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/models/color_config_model.dart';
import 'package:maginot/repos/color_config_repo.dart';

class ColorsConfigViewModel extends ChangeNotifier {
  final ColorConfigRepository _repository;

  late final _model = ColorsConfigModel(
    completeColor: _repository.getCompleteColor(),
    incompleteColor: _repository.getIncompleteColor(),
    pastdayColor: _repository.getPastDayColor(),
  );

  ColorsConfigViewModel(this._repository);

  int get completeColor => _model.completeColor;
  int get incompleteColor => _model.incompleteColor;
  int get pastdayColor => _model.pastdayColor;

  void setColor(String name, int hexcode) {
    _repository.setColor(name, hexcode);
    if (name == complete) {
      _model.completeColor = hexcode;
    } else if (name == incomplete) {
      _model.incompleteColor = hexcode;
    } else {
      _model.pastdayColor = hexcode;
    }
    notifyListeners();
  }

  void defaultColor() {
    _repository.setColor(complete, 0xFFFFEB3B);
    _repository.setColor(incomplete, 0xFFEF5350);
    _repository.setColor(pastday, 0xFF66BB6A);
    _model.completeColor = 0xFFFFEB3B;
    _model.incompleteColor = 0xFFEF5350;
    _model.pastdayColor = 0xFF66BB6A;
    notifyListeners();
  }
}
