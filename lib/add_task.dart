import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'custom_widgets.dart';
import 'main.dart';

class MicoMiSubPage extends StatefulWidget {
  const MicoMiSubPage({super.key, this.editTask});

  final Task? editTask;

  @override
  State<MicoMiSubPage> createState() => AddTask();
}

class AddTask extends State<MicoMiSubPage> {
  late DateTimeRange? taskDateRange = widget.editTask == null
      ? null
      : DateTimeRange(start: widget.editTask!.start, end: widget.editTask!.end);
  late String? taskName = widget.editTask?.name;
  late String? taskDetail = widget.editTask?.detail;

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

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("タスクの追加"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CustomMargin(height: 20),
                CustomTextField(
                  initialValue: taskName,
                  hintText: "タスクの名前を入力",
                  textStyle: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  ),
                  isUnderline: true,
                  isTextAlignCenter: true,
                  onChanged: (value) => {taskName = value},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "タスクの名前を入力してください。";
                    }
                    return null;
                  },
                ),
                const CustomMargin(height: 30),
                CustomTextField(
                  initialValue: taskDetail,
                  isMultiline: true,
                  isUnderline: false,
                  hintText: "くわしく\n\n\n\n\n",
                  onChanged: (value) => {taskDetail = value},
                ),
                const CustomMargin(height: 10),
                CustomElevatedButton(
                  label: taskDateRange == null
                      ? "期間を決める"
                      : "${formatter.format(taskDateRange!.start)} ～ ${formatter.format(taskDateRange!.end)}",
                  isPrimary: false,
                  isRoundedSquare: true,
                  width: 300,
                  onPressed: () => {
                    Vibration.vibrate(duration: 10),
                    pickDateRange(context),
                  },
                ),
                const CustomMargin(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      label: "決定！",
                      isPrimary: true,
                      isRoundedSquare: false,
                      onPressed: () {
                        Vibration.vibrate(duration: 10);
                        if (formKey.currentState!.validate()) {
                          insertTask(Task(
                            id: widget.editTask?.id,
                            name: taskName!,
                            detail: taskDetail ?? "",
                            start: taskDateRange!.start,
                            end: taskDateRange!.end,
                          ));
                          Navigator.popUntil(
                            context,
                            (Route<dynamic> route) => route.isFirst,
                          );
                        }
                      },
                    ),
                    const CustomMargin(width: 10),
                    CustomElevatedButton(
                      label: "やっぱやめる",
                      isPrimary: false,
                      isRoundedSquare: false,
                      onPressed: () {
                        Vibration.vibrate(duration: 10);
                        if (taskName != null && taskName != "" ||
                            taskDetail != null && taskDetail != "" ||
                            taskDateRange != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("確認"),
                                content: const Text(
                                    "タスクの追加をやめますか？\n入力した内容は保存されません。"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("やめる"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.popUntil(
                                        context,
                                        (Route<dynamic> route) => route.isFirst,
                                      );
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("やめない"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.popUntil(
                            context,
                            (Route<dynamic> route) => route.isFirst,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
