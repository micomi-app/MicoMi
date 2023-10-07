import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import 'package:navigator_scope/navigator_scope.dart';
import 'edit_task.dart';
import 'custom_material_app.dart';
import 'custom_widgets.dart';
import 'custom_functions.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const Main()));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]).then((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
    });
    return const CustomMaterialApp(
      title: 'MicoMi',
      home: MainPage(title: 'MicoMi'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  // pageに基づいてStateを返す
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Task? _selectedTask;
  int _currentDestination = 0;
  String _orderBy = "id";
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward();
  late final Animation<double> _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const CustomMargin(height: 20),
            // カレンダー
            TableCalendar(
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme(context).primary,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme(context).onPrimary,
                        ),
                      ),
                    ),
                  );
                },
                rangeStartBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: toSecondaryColorSL(context, _selectedTask?.color),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: theme(context).onSecondary,
                        ),
                      ),
                    ),
                  );
                },
                rangeEndBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: toSecondaryColorSL(context, _selectedTask?.color),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: theme(context).onSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                // ここに書いてもマーカーデザイン実装できるけど、
                // フェードアニメーションがついて違和感ある感じになってしまうので
                // 今回はCalendarBuildersで実装
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme(context).primary,
                    width: 1,
                  ),
                ),
                todayTextStyle: TextStyle(
                  color: theme(context).primary,
                ),
                rangeHighlightColor:
                    toSecondaryColorSL(context, _selectedTask?.color) ?? theme(context).secondary,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              daysOfWeekHeight: 32,
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(9999, 12, 31),
              focusedDay: _focusedDay,
              rangeStartDay: _selectedTask?.start,
              rangeEndDay: _selectedTask?.end,
              locale: Localizations.localeOf(context).toString(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              onDaySelected: (selectedDay, focusedDay) {
                Vibration.vibrate(duration: 10);
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),

            FutureBuilder(
              builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      for (final task in snapshot.data!) taskCard(task),
                      const CustomMargin(height: 170),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              future: getTasks(
                "start <= ? AND end >= ?",
                [formatterForSQL.format(_selectedDay), formatterForSQL.format(_selectedDay)],
              ),
            ),
          ],
        ),
      ),
      FutureBuilder(
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const CustomMargin(height: 20),
                        for (final task in snapshot.data!) taskCard(task),
                        if (snapshot.data!.isEmpty)
                          const Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline),
                              CustomMargin(width: 10),
                              Text(
                                "タスクはありません",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 170,
                  child: DropdownButton(
                    items: const [
                      DropdownMenuItem(
                        value: "id",
                        child: Text("追加が新しい順"),
                      ),
                      DropdownMenuItem(
                        value: "id DESC",
                        child: Text("追加が古い順"),
                      ),
                      DropdownMenuItem(
                        value: "color",
                        child: Text("色順"),
                      ),
                      DropdownMenuItem(
                        value: "name",
                        child: Text("タスク名順"),
                      ),
                      DropdownMenuItem(
                        value: "start",
                        child: Text("開始日が古い順"),
                      ),
                      DropdownMenuItem(
                        value: "end",
                        child: Text("終了日が古い順"),
                      ),
                    ],
                    onChanged: (value) {
                      Vibration.vibrate(duration: 10);
                      setState(() {
                        _orderBy = value!;
                      });
                    },
                    value: _orderBy,
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        future: getTasks("1", [], _orderBy),
      ),
      const Center(
        child: Text("設定"),
      ),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme(context).primary,
        foregroundColor: theme(context).onPrimary,
        title: Text(widget.title),
      ),
      body: NavigatorScope(
        currentDestination: _currentDestination,
        destinationCount: 3,
        destinationBuilder: (context, index) {
          return FadeTransition(
            opacity: _animation,
            child: pages[index],
          );
        },
      ),

      // タスク追加ボタン
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: theme(context).onPrimary,
        backgroundColor: theme(context).primary,
        onPressed: () {
          Vibration.vibrate(duration: 20);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const EditPage();
          })).then((value) {
            setState(() {});
          });
        },
        label: const Text("タスクを追加"),
        icon: const Icon(Icons.add),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentDestination,
        onDestinationSelected: (index) {
          Vibration.vibrate(duration: 10);
          setState(() {
            _currentDestination = index;
            _controller.reset();
            _controller.forward();
          });
        },
        backgroundColor: theme(context).background.withOpacity(0.7),
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: "カレンダー",
            tooltip: "カレンダー",
            selectedIcon: Icon(Icons.calendar_month),
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: "タスク一覧",
            tooltip: "タスク一覧",
            selectedIcon: Icon(Icons.checklist),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "設定",
            tooltip: "設定",
            selectedIcon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  Widget taskCard(Task task) {
    return SizedBox(
      width: 300,
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: toSecondaryColorSL(context, task.color),
        child: InkWell(
          onTap: () {
            Vibration.vibrate(duration: 10);
            if (_selectedTask?.id != task.id) {
              setState(() {
                _selectedTask = task;
              });
            } else {
              setState(() {
                _selectedTask = null;
              });
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 190,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomMargin(height: 15),
                    Text(
                      task.name,
                      style: TextStyle(
                        color: theme(context).onSecondary,
                      ),
                    ),
                    if (task.detail != "")
                      Text(
                        task.detail,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: theme(context).onSecondary.withOpacity(0.7),
                        ),
                      ),
                    const CustomMargin(height: 15),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                child: IconButton(
                  onPressed: () {
                    Vibration.vibrate(duration: 10);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("タスクの削除"),
                          content: Text("タスク「${task.name}」を削除しますか？"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Vibration.vibrate(duration: 10);
                                Navigator.pop(context);
                              },
                              child: const Text("キャンセル"),
                            ),
                            TextButton(
                              onPressed: () {
                                Vibration.vibrate(duration: 10);
                                Navigator.pop(context);
                                setState(() {
                                  deleteTask(task);
                                });
                              },
                              child: const Text("削除"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ),
              Positioned(
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Vibration.vibrate(duration: 10);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return EditPage(
                          editTask: task,
                        );
                      }),
                    ).then((value) {
                      _selectedTask = null;
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
