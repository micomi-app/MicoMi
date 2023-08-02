import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import 'package:sqflite/sqflite.dart';
import 'edit_task.dart';
import 'custom_material_app.dart';
import 'custom_widgets.dart';

DateFormat formatterForSQL = DateFormat('yyyy-MM-dd');

class Task {
  Task({
    this.id,
    required this.name,
    required this.detail,
    required this.start,
    required this.end,
  });

  final int? id;
  final String name;
  final String detail;
  final DateTime start;
  final DateTime end;
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'detail': detail,
      'start': formatterForSQL.format(start),
      'end': formatterForSQL.format(end),
    };
  }
}

final Future<Database> database = openDatabase(
  "tasks.db",
  onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, detail TEXT, start TEXT, end TEXT)',
    );
  },
  version: 3,
);

Future<void> insertTask(Task task) async {
  final Database db = await database;
  if (task.id == null) {
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } else {
    await db.update(
      'tasks',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }
}

Future<void> deleteTask(int id) async {
  final Database db = await database;
  await db.delete(
    'tasks',
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<List<Task>> getTasks(String query) async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query(query);
  return List.generate(maps.length, (i) {
    return Task(
      id: maps[i]['id'],
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
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Task? _selectedTask;

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
                rangeStartBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
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
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                selectedTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
                todayTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                rangeHighlightColor: Theme.of(context).colorScheme.secondary,
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
                      const CustomMargin(height: 80),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              future: getTasks("tasks WHERE start <= '${formatterForSQL.format(_selectedDay)}' AND end >= '${formatterForSQL.format(_selectedDay)}'"),
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
            return const MicoMiSubPage();
          })).then((value) {
            setState(() {});
          });
        },
        label: const Text("タスクを追加"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget taskCard(Task task) {
    return SizedBox(
      width: 300,
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.secondary,
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
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    if (task.detail != "")
                      Text(
                        task.detail,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
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
                                  deleteTask(task.id!);
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
