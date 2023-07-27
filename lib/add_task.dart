import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'custom_material_app.dart';
import 'custom_widgets.dart';

class MicoMiSubPage extends StatefulWidget {
  const MicoMiSubPage({super.key, required this.title});

  final String title;

  @override
  State<MicoMiSubPage> createState() => AddTask();
}

class AddTask extends State<MicoMiSubPage> {
  DateTimeRange? taskDateRange;
  @override
  Widget build(BuildContext context) {
    Future pickDateRange(BuildContext context) async {
      final DateTimeRange initialDateRange = taskDateRange == null
          ? DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 1)),
            )
          : taskDateRange!;

      final DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: initialDateRange,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 3),
        locale: Localizations.localeOf(context),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              colorScheme: Theme.of(context).colorScheme,
              useMaterial3: true,
            ),
            child: child!,
          );
        },
      );
      if (newDateRange != null) {
        setState(() => taskDateRange = newDateRange);
      } else {
        return;
      }
    }

    DateFormat formatter =
        DateFormat('yyyy/MM/dd(E)', Localizations.localeOf(context).toString());
    String? taskName;
    String? taskDetail;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("タスクの追加"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CustomMargin(height: 20),
              CustomTextField(
                hintText: "タスクの名前を入力",
                textStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                ),
                isUnderline: true,
                autoFocus: true,
                isTextAlignCenter: true,
                onChanged: (value) => {taskName = value},
              ),
              const CustomMargin(height: 30),
              CustomTextField(
                  isMultiline: true,
                  isUnderline: false,
                  hintText: "くわしく\n\n\n\n\n",
                  onChanged: (value) => {taskDetail = value}),
              const CustomMargin(height: 10),
              CustomElevatedButton(
                label: taskDateRange == null
                    ? "期間を決める"
                    : "${formatter.format(taskDateRange!.start)} ～ ${formatter.format(taskDateRange!.end)}",
                isPrimary: false,
                isRoundedSquare: true,
                width: 300,
                onPressed: () => {pickDateRange(context)},
              ),
              const CustomMargin(height: 20),
              CustomElevatedButton(
                label: "決定！",
                isPrimary: true,
                isRoundedSquare: false,
                onPressed: () {
                  Vibration.vibrate(duration: 10);
                  Navigator.popUntil(
                    context,
                    (Route<dynamic> route) => route.isFirst,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
