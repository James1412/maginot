import 'package:flutter/material.dart';
import 'package:maginot/models/is_vertical_model.dart';
import 'package:maginot/repos/is_vertical_repo.dart';

class IsVerticalViewModel extends ChangeNotifier {
  final IsVerticalRepository _repository;

  late final _model = IsVerticalModel(isVertical: _repository.isVertical());

  IsVerticalViewModel(this._repository);

  bool get isVertical => _model.isVertical;

  void setVertical(bool value) {
    _repository.setIsVertical(value);
    _model.isVertical = value;
    notifyListeners();
  }
}
