import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maginot/box_names.dart';

class NotificationIDCounter extends ChangeNotifier {
  int id = 0;

  final idBox = Hive.box(idBoxName);

  void incrementIdByTwo() {
    id += 2;
    if (idBox.get('id') == null) {
      idBox.put('id', 0);
    }
    idBox.put('id', idBox.get('id') + 3);
    notifyListeners();
  }
}
