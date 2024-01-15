import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/components/maginot_dialog.dart';
import 'package:maginot/components/yearly_calendar_heat_map.dart';
import 'package:maginot/screens/settings.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:maginot/view_models/is_vertical_vm.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final taskBox;
  final taskdb;
  const HomeScreen({super.key, required this.taskBox, required this.taskdb});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(
      initialScrollOffset: (DateTime.utc(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day)
                  .difference(DateTime(2024, 1, 1))
                  .inDays /
              7) /
          52 *
          2641);

  @override
  void initState() {
    super.initState();
    if (widget.taskBox.get(taskBoxName) == null) {
      widget.taskdb.createInitialData();
    } else {
      widget.taskdb.loadData();
    }
    widget.taskdb.updateDataBase();
  }

  Future<void> onSettingsTap(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ));
  }

  Future<void> onAddDeadlinePressed() async {
    List? textAndDates = await showDialog(
      context: context,
      builder: (context) => MaginotDialog(
        controller: _controller,
      ),
    );
    if (textAndDates != null) {
      widget.taskdb.deadlines.add([textAndDates[1], 2, textAndDates[0], false]);
      setState(() {});
    }
    widget.taskdb.updateDataBase();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onListTileTap(int index) {
    setState(() {
      widget.taskdb.deadlines[index][3] = !widget.taskdb.deadlines[index][3];
      if (widget.taskdb.deadlines[index][3]) {
        widget.taskdb.deadlines[index][1] = 3;
      } else {
        widget.taskdb.deadlines[index][1] = 2;
      }
    });
    widget.taskdb.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text("M A G I N O T"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () => onSettingsTap(context),
                child: const FaIcon(FontAwesomeIcons.gear),
              ),
            ),
          ],
        ),
        body: context.watch<IsVerticalViewModel>().isVertical
            ? Scrollbar(
                thickness: 5,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: HeatMapWidget(
                    deadlines: widget.taskdb.deadlines,
                  ),
                ),
              )
            : HeatMapWidget(
                deadlines: widget.taskdb.deadlines,
              ),
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(microseconds: 100),
          opacity: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 1 : 0,
          child: FloatingActionButton(
            heroTag: "home",
            splashColor:
                Color(context.watch<ColorsConfigViewModel>().pastdayColor),
            backgroundColor:
                Color(context.watch<ColorsConfigViewModel>().pastdayColor)
                    .withOpacity(0.7),
            foregroundColor: Colors.white,
            onPressed: onAddDeadlinePressed,
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
      ),
    );
  }
}
