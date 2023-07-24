import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicoMi',
      theme: ThemeData(
        primaryColor: const Color(0xff8daeb8),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xff4e7682),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'MicoMi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => CalendarPage();
}

class CalendarPage extends State<MyHomePage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // 余白
          const SizedBox(
            width: 100,
            height: 20,
          ),
          // カレンダー
          TableCalendar(
            calendarBuilders: CalendarBuilders(
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
                    child: Text(day.day.toString()),
                  )
                );
              }
            ),
            calendarStyle: const CalendarStyle(
                isTodayHighlighted: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(9999, 12, 31),
            focusedDay: _focusedDay,
            locale: 'ja_JP',
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              Vibration.vibrate(duration: 10);
              // TODO:タスク一覧表示の作成
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
          ),
        ],
      ),

      // タスク追加ボタン
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Vibration.vibrate(duration: 20);
          // TODO: タスク追加の作成
        },
        label: const Text("タスクを追加"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
