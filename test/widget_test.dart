import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ios_android_flutter/widgets/login_widget.dart';
import 'package:ios_android_flutter/widgets/main_widget.dart';

void main() {
  testWidgets("test auth interface", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        locale: Locale('en'),
        home: LoginWidget()));
    await tester.pump();
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(Text), findsNWidgets(6));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
  
  testWidgets("test auth interface to Register screen click", (WidgetTester tester) async {
    var toRegisterScreen = find.byKey(ValueKey("toRegister"));

    await tester.pumpWidget(MaterialApp(
        locale: Locale('en'),
        home: LoginWidget()));
    await tester.pump();
    await tester.tap(toRegisterScreen);
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Text), findsNWidgets(7));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets("test main interface", (WidgetTester tester) async {
    var addTask = find.byKey(ValueKey("addTask"));

    await tester.pumpWidget(MaterialApp(
        locale: Locale('en'),
        home: MainWidget(needToWrap: false)));
    await tester.pump();
    await tester.tap(addTask);
    await tester.pump(Duration(seconds: 2));

    expect(find.byType(Text), findsNWidgets(4));
  });
}
