import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'custom_material_app.dart';
import 'custom_widgets.dart';

class MicoMiSub extends StatelessWidget {
  const MicoMiSub({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomMaterialApp(
      title: 'MicoMi',
      home: MicoMiSubPage(title: 'MicoMi'),
    );
  }
}

class MicoMiSubPage extends StatefulWidget {
  const MicoMiSubPage({super.key, required this.title});

  final String title;

  @override
  State<MicoMiSubPage> createState() => AddTask();
}

class AddTask extends State<MicoMiSubPage> {
  DateTimeRange? selectedDateRange;
  Future _pickDateRange(BuildContext context) async {
    final DateTimeRange initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 1)),
    );

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
          ),
          child: child!,
        );
      },
    );

    if (newDateRange != null) {
      setState(() => selectedDateRange = newDateRange);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateFormat formatter =
        DateFormat('yyyy/MM/dd(E)', Localizations.localeOf(context).toString());
    return CustomMaterialApp(
      title: 'MicoMi',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
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
                ),
                const CustomMargin(height: 30),
                const CustomTextField(
                  isMultiline: true,
                  isUnderline: false,
                  hintText: "詳細\n\n\n\n\n",
                ),
                const CustomMargin(height: 10),
                CustomElevatedButton(
                  label: selectedDateRange == null
                      ? "期間を設定"
                      : "${formatter.format(selectedDateRange!.start)} ～ ${formatter.format(selectedDateRange!.end)}",
                  isPrimary: false,
                  isRoundedSquare: true,
                  width: 300,
                  onPressed: () => {_pickDateRange(context)},
                ),
                const CustomMargin(height: 20),
                CustomElevatedButton(
                  label: "決定！",
                  isPrimary: true,
                  isRoundedSquare: false,
                  onPressed: () {
                    Vibration.vibrate(duration: 10);
                    // TODO: タスク追加処理の追加
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
      ),
    );
  }
}
