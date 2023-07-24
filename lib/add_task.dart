import 'package:flutter/material.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MicoMi',
        theme: ThemeData(
          primaryColor: const Color(0xff8daeb8),
          brightness: Brightness.light,
          useMaterial3: true,
          fontFamily: "Noto Sans JP"
        ),
        darkTheme: ThemeData(
          primaryColor: const Color(0xff4e7682),
          brightness: Brightness.dark,
          useMaterial3: true,
            fontFamily: "Noto Sans JP"
        ),
        themeMode: ThemeMode.system,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text("タスクの追加"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // 余白
                const SizedBox(
                  width: 100,
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "タスクの名前を入力",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        )
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        )
                      )
                    ),
                  )
                ),
              ]
            )
          ),
        )
    );
  }
}
