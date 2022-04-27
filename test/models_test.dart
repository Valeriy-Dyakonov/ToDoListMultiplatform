import 'package:flutter_test/flutter_test.dart';
import 'package:ios_android_flutter/model/response_token.dart';
import 'package:ios_android_flutter/sqlite/task_model.dart';

void main() {
  test('Response token constructor', () async {
    var value = ResponseToken(token: "Token");
    expect("Token", value.token);
  });

  test('Response token from Map', () async {
    Map<String, dynamic> json = {'token': "Token"};
    var value = ResponseToken.fromJson(json);
    expect("Token", value.token);
  });

  test('Task constructor', () async {
    var value = Task(
        category: 'Home',
        name: 'Task 1',
        content: 'Content',
        selected: false,
        done: "false",
        date: "24/12/2022 12:12");
    expect('Home', value.category);
    expect('Task 1', value.name);
    expect('Content', value.content);
    expect(false, value.selected);
    expect("false", value.done);
    expect(null, value.id);
  });

  test('Task from Map', () async {
    Map<String, dynamic> json = {
      'category': 'Home',
      'name': 'Task 1',
      'content': 'Content',
      'id': 1,
      'done': "false",
      'date': "24/12/2022 12:12"
    };
    var value = Task.fromMap(json);
    expect('Home', value.category);
    expect('Task 1', value.name);
    expect('Content', value.content);
    expect(false, value.selected);
    expect("false", value.done);
    expect(1, value.id);
  });

  test('Task from Map', () async {
    var value = Task(
        category: 'Home',
        name: 'Task 1',
        content: 'Content',
        selected: false,
        done: "false",
        date: "24/12/2022 12:12");
    var json = value.toMap();
    expect({
      'name': 'Task 1',
      'category': 'Home',
      'date': "24/12/2022 12:12",
      'content': 'Content',
      'done': "false"
    }, json);
  });
}
