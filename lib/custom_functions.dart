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


final Future<Database> database = openDatabase(
  "tasks.db",
  onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE tasks('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'isHomework INTEGER,'
          'difficulty INTEGER,'
          'totalPages INTEGER,'
          'name TEXT,'
          'detail TEXT,'
          'start TEXT,'
          'end TEXT,'
          'color INTEGER'
          ')',
    );
  },
  version: 3,
);

class Task {
  Task({
    this.id,
    required this.isHomework,
    this.difficulty,
    this.totalPages,
    required this.name,
    required this.detail,
    required this.start,
    required this.end,
    required this.color,
  });

  final int? id;
  final bool isHomework;
  final int? difficulty;
  final int? totalPages;
  final String name;
  final String detail;
  final DateTime start;
  final DateTime end;
  final Color color;
  Map<String, dynamic> toMap() {
    return {
      'isHomework': isHomework ? 1 : 0,
      'difficulty': difficulty,
      'totalPages': totalPages,
      'name': name,
      'detail': detail,
      'start': formatterForSQL.format(start),
      'end': formatterForSQL.format(end),
      'color': color.value,
    };
  }

  Future<void> insert() async {
    final Database db = await database;
    if (id == null) {
      await db.insert(
        'tasks',
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update(
        'tasks',
        toMap(),
        where: "id = ?",
        whereArgs: [id],
      );
    }
  }
  Future<void> delete() async {
    final Database db = await database;
    await db.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

Future<List<Task>> getTasks(String where, List? whereArgs, [String? orderBy]) async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'tasks',
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
  );
  return List.generate(maps.length, (i) {
    return Task(
      id: maps[i]['id'],
      isHomework: maps[i]['isHomework'] == 1,
      difficulty: maps[i]['difficulty'],
      totalPages: maps[i]['totalPages'],
      name: maps[i]['name'],
      detail: maps[i]['detail'],
      start: DateTime.parse(maps[i]['start']),
      end: DateTime.parse(maps[i]['end']),
      color: Color(maps[i]['color']),
    );
  });
}
