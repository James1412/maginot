import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:maginot/ad_helper.dart';
import 'package:maginot/box_names.dart';
import 'package:maginot/screens/settings.dart';
import 'package:maginot/services/notification_service.dart';
import 'package:maginot/view_models/color_config_vm.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  final taskBox;
  final taskdb;
  final Function onAdd;
  final Function onDeleteTask;
  final Function(List, int) onAddNotification;
  const TaskListScreen(
      {super.key,
      required this.taskBox,
      required this.taskdb,
      required this.onAdd,
      required this.onDeleteTask,
      required this.onAddNotification});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    if (widget.taskBox.get(taskBoxName) == null) {
      widget.taskdb.createInitialData();
    } else {
      widget.taskdb.loadData();
    }
    widget.taskdb.updateDataBase();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _ad = ad as BannerAd;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Ad load failed (code=${error.code}) message=${error.message}")),
        );
      }),
    ).load();
  }

  void onSettingsTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onListTileTap(int index) async {
    widget.taskdb.deadlines[index][3] = !widget.taskdb.deadlines[index][3];
    // If finished
    if (widget.taskdb.deadlines[index][3]) {
      widget.taskdb.deadlines[index][1] = 3;
      await NotificationService()
          .cancelScheduledNotification(widget.taskdb.deadlines[index][4]);
      await NotificationService()
          .cancelScheduledNotification(widget.taskdb.deadlines[index][4] * -1);
    }
    // If changed to not finished
    else {
      widget.taskdb.deadlines[index][1] = 2;
      await widget.onAddNotification(
        [
          widget.taskdb.deadlines[index][2],
          widget.taskdb.deadlines[index][0],
        ],
        widget.taskdb.deadlines[index][4],
      );
    }
    setState(() {});
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
                onTap: onSettingsTap,
                child: const FaIcon(FontAwesomeIcons.gear),
              ),
            ),
          ],
        ),
        body: widget.taskdb.deadlines.length == 0
            ? const Center(
                child: Text("Add a new task!"),
              )
            : ListView(
                children: [
                  if (_ad != null)
                    Container(
                      width: _ad!.size.width.toDouble(),
                      height: 72,
                      alignment: Alignment.center,
                      child: AdWidget(ad: _ad!),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.taskdb.deadlines.length,
                    itemBuilder: (context, index) => InkWell(
                      splashFactory: InkRipple.splashFactory,
                      onTap: () => onListTileTap(index),
                      child: Slidable(
                        key: const ValueKey(0),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          dismissible: DismissiblePane(
                              key: UniqueKey(),
                              onDismissed: () =>
                                  widget.onDeleteTask(index, context)),
                          children: [
                            SlidableAction(
                              borderRadius: BorderRadius.circular(5),
                              backgroundColor: Colors.red,
                              onPressed: (value) =>
                                  widget.onDeleteTask(index, context),
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: ListTile(
                          shape: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade400, width: 0.4)),
                          title: Text(
                            widget.taskdb.deadlines[index][2],
                            style: TextStyle(
                              decoration: widget.taskdb.deadlines[index][3]
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(widget.taskdb.deadlines[index][0]
                              .toString()
                              .split(" ")[0]),
                          leading: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) => onListTileTap(index),
                            value: widget.taskdb.deadlines[index][3],
                          ),
                          trailing: const Icon(Icons.chevron_left),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(microseconds: 100),
          opacity: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 1 : 0,
          child: FloatingActionButton(
            heroTag: "List",
            splashColor:
                Color(context.watch<ColorsConfigViewModel>().pastdayColor),
            backgroundColor:
                Color(context.watch<ColorsConfigViewModel>().pastdayColor)
                    .withOpacity(0.7),
            foregroundColor: Colors.white,
            onPressed: () => widget.onAdd(_controller, context),
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
      ),
    );
  }
}
