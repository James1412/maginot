import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/screens/bottom_navigation.dart';
import 'package:maginot/repos/color_config_repo.dart';
import 'package:maginot/repos/is_vertical_repo.dart';
import 'package:maginot/services/notification_id_counter.dart';
import 'package:maginot/services/notification_service.dart';
import 'package:maginot/utils.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:maginot/view_models/is_vertical_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(colorBoxName);
  await Hive.openBox(isverticalBoxName);
  await Hive.openBox(taskBoxName);
  await Hive.openBox(idBoxName);

  NotificationService().initNotification();

  final colorRepository = ColorConfigRepository();
  final verticalRepository = IsVerticalRepository();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ColorsConfigViewModel(colorRepository)),
        ChangeNotifierProvider(
            create: (context) => IsVerticalViewModel(verticalRepository)),
        ChangeNotifierProvider(create: (context) => NotificationIDCounter()),
      ],
      child: const MaginotApp(),
    ),
  );
}

class MaginotApp extends StatelessWidget {
  const MaginotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: getMaterialColor(
            Color(context.watch<ColorsConfigViewModel>().pastdayColor)),
        primaryColor:
            Color(context.watch<ColorsConfigViewModel>().pastdayColor),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade200,
          shadowColor: Colors.grey.shade200,
          surfaceTintColor: Colors.grey.shade200,
        ),
        scaffoldBackgroundColor: Colors.grey.shade200,
        dialogBackgroundColor: Colors.grey.shade100,
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey.shade100,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
        ),
      ),
      home: const BottomNavigationScreen(),
    );
  }
}
