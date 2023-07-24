import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import 'add_task.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MicoMiMain()));
}

class MicoMiMain extends StatelessWidget {
  const MicoMiMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicoMi',
      theme: ThemeData(
        primaryColor: const Color(0xff8daeb8),
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xff4e7682),
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: "Noto Sans JP",
      ),
      themeMode: ThemeMode.system,
      home: const MicoMiMainPage(title: 'MicoMi'),
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
                _focusedDay = focusedDay;
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
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const AddTask(),
          ));
        },
        label: Text(
          "タスクを追加",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
