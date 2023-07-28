import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import 'package:sqflite/sqflite.dart';
import 'add_task.dart';
import 'custom_material_app.dart';
import 'custom_widgets.dart';

class Task {
  Task({
    required this.name,
    required this.detail,
    required this.start,
    required this.end,
  });

  final String name;
  final String? detail;
  final DateTime start;
  final DateTime end;
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'detail': detail,
      'start': start.toString(),
      'end': end.toString(),
    };
  }
}

final Future<Database> database = openDatabase(
  "tasks.db",
  onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY, name TEXT, detail TEXT, start TEXT, end TEXT)',
    );
  },
  version: 1,
);

Future<void> insertTask(Task task) async {
  final Database db = await database;
  await db.insert(
    'tasks',
    task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Task>> getTasks() async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('tasks');
  return List.generate(maps.length, (i) {
    return Task(
      name: maps[i]['name'],
      detail: maps[i]['detail'],
      start: DateTime.parse(maps[i]['start']),
      end: DateTime.parse(maps[i]['end']),
    );
  });
}

void main() {
  initializeDateFormatting().then((_) => runApp(const MicoMiMain()));
}

class MicoMiMain extends StatelessWidget {
  const MicoMiMain({super.key});

  @override
  Widget build(BuildContext context) {
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
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                todayBuilder: (context, day, focusedDay) {
                  // 今日のマークに相当するウィジェットを返す関数
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      alignment: const Alignment(0.0, 0.0),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  // 日付フォーカス時のマークに相当するウィジェットを返す関数
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      alignment: const Alignment(0.0, 0.0),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(9999, 12, 31),
              focusedDay: _focusedDay,
              locale: Localizations.localeOf(context).toString(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                Vibration.vibrate(duration: 10);
                // TODO:タスク一覧表示の作成
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),

            FutureBuilder(
              builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                if (snapshot.hasData) {
                  final List<Task> tasks = snapshot.data!;
                  return SizedBox(
                    width: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Theme.of(context).colorScheme.secondary,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(tasks[index].name),
                                Text(
                                  tasks[index].detail ?? "N/A",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withOpacity(0.5)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              future: getTasks(),
            ),
          ],
        ),
      ),

      // タスク追加ボタン
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          Vibration.vibrate(duration: 20);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MicoMiSubPage(title: "タスクの追加");
          })).then((value) {
            setState(() {});
          });
        },
        label: const Text("タスクを追加"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
