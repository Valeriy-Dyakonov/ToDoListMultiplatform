import 'package:flutter/material.dart';
import 'package:ios_android_flutter/widgets/login_widget.dart';
import 'package:ios_android_flutter/widgets/main_widget.dart';

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
        home: SafeArea(child: MainWidget()));
  }
}
