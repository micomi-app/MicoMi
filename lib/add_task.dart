import 'package:flutter/material.dart';
import 'custom_material_app.dart';
import 'custom_widgets.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomMaterialApp(
        title: 'MicoMi',
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text("タスクの追加"),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CustomPadding(height: 20),
                CustomTextField(hintText: "タスクの名前を入力"),
                CustomTextField(hintText: "タスクを追加"),
              ]
            )
          ),
        )
    );
  }
}