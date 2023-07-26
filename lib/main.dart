import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';
import 'add_task.dart';
import 'custom_material_app.dart';
import 'custom_widgets.dart';

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
          }));
        },
        label: const Text("タスクを追加"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
