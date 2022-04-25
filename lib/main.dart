import 'package:flutter/material.dart';
import 'package:ios_android_flutter/sqlite/task_model.dart';
import 'package:ios_android_flutter/widgets/edit_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Organizer',
        theme:
            ThemeData(fontFamily: 'sans-serif-light', errorColor: Colors.red),
        home: SafeArea(
            child: EditWidget(
                task: Task(
                    id: 1,
                    name: "Task 1",
                    category: "Home",
                    date: "22/12/2022 22:23",
                    content: "Content 1",
                    done: "true",
                    selected: false))));
  }
}
