import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

Color withNewHue(Color color, double hue) {
  return HSLColor.fromColor(color).withHue(hue).toColor();
}

double getHue(Color color) {
  return HSLColor.fromColor(color).hue;
}

ColorScheme theme(BuildContext context) {
  return Theme.of(context).colorScheme;
}

Color? toSecondaryColorSL(BuildContext context, Color? color) {
  if (color == null) return null;
  return withNewHue(theme(context).secondary, getHue(color));
}

DateFormat formatterForSQL = DateFormat('yyyy-MM-dd');

class Task {
  Task({
    this.id,
    required this.name,
    required this.detail,
    required this.start,
    required this.end,
    required this.color,
  });

  final int? id;
  final String name;
  final String detail;
  final DateTime start;
  final DateTime end;
  final Color color;
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'detail': detail,
      'start': formatterForSQL.format(start),
      'end': formatterForSQL.format(end),
      'color': color.value,
    };
  }
}

final Future<Database> database = openDatabase(
  "tasks.db",
  onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, detail TEXT, start TEXT, end TEXT, color INTEGER)',
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

Future<void> deleteTask(Task task) async {
  final Database db = await database;
  await db.delete(
    'tasks',
    where: "id = ?",
    whereArgs: [task.id],
  );
}

Future<List<Task>> getTasks(String query, List? whereArgs) async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'tasks',
    where: query,
    whereArgs: whereArgs,
  );
  return List.generate(maps.length, (i) {
    return Task(
      id: maps[i]['id'],
      name: maps[i]['name'],
      detail: maps[i]['detail'],
      start: DateTime.parse(maps[i]['start']),
      end: DateTime.parse(maps[i]['end']),
      color: Color(maps[i]['color']),
    );
  });
}
