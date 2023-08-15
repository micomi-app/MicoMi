import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import 'edit_task.dart';
import 'custom_material_app.dart';
import 'custom_widgets.dart';
import 'custom_functions.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MicoMiMain()));
}

class MicoMiMain extends StatelessWidget {
  const MicoMiMain({super.key});

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
      home: MicoMiMainPage(title: 'MicoMi'),
    );
  }
}

class MicoMiMainPage extends StatefulWidget {
  const MicoMiMainPage({super.key, required this.title});

  final String title;

  @override
  State<MicoMiMainPage> createState() => CalendarPage();
}

class CalendarPage extends State<MicoMiMainPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Task? _selectedTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme(context).primary,
        foregroundColor: theme(context).onPrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
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

      // タスク追加ボタン
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: theme(context).onPrimary,
        onPressed: () {
          Vibration.vibrate(duration: 20);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MicoMiSubPage();
          })).then((value) {
            setState(() {});
          });
        },
        label: const Text("タスクを追加"),
        icon: const Icon(Icons.add),
      ),

      bottomNavigationBar: NavigationBar(
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
                        return MicoMiSubPage(
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
