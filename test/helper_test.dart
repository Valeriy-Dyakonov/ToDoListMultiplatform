import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ios_android_flutter/helpers/theme.dart';
import 'package:ios_android_flutter/helpers/validation_errors.dart';

import 'package:ios_android_flutter/utils/helper.dart';

void main() {
  test('Test bool to String', () async {
    expect("true", Helper.boolToString(true));
  });

  test('Test String to bool', () async {
    expect(true, Helper.parseBool("true"));
  });

  test('parse date for card', () async {
    expect("12 Dec 2022 12:30", Helper.parseDateForCard("12/12/2022 12:30"));
  });

  test('parse date', () async {
    var value = Helper.parseDate("12/12/2022 12:30") as DateTime;
    expect(12, value.day);
    expect(12, value.month);
    expect(2022, value.year);
    expect(12, value.hour);
    expect(30, value.minute);
  });

  test('date to string', () async {
    var datetime = DateTime.now();
    var created = Helper.dateToString(datetime) as String;
    expect(true, created.isNotEmpty);
  });

  test('full date to String', () async {
    var datetime = DateTime.now();
    var created = Helper.fullDateToString(datetime);
    expect(0, datetime.difference(Helper.parseDate(created)).inDays);
  });

  test('get time from date', () async {
    var datetime = DateTime.now();
    var created = Helper.getTimeFromDateTime(datetime) as TimeOfDay;
    expect(datetime.hour, created.hour);
    expect(datetime.minute, created.minute);
  });

  test('time to String', () async {
    var datetime = DateTime.now();
    var time = Helper.getTimeFromDateTime(datetime) as TimeOfDay;
    var created = Helper.timeToString(time);
    expect(time.hour.toString() + ":" + time.minute.toString(), created);
  });

  test('get diff from today', () async {
    var datetime = DateTime.now();
    var dateString = Helper.fullDateToString(datetime);
    expect(0, Helper.getDiffFromToday(dateString));
  });

  test('capitalize String', () async {
    String s = "tESt ";
    expect("Test", Helper.capitalizeString(s));
  });

  test('custom hex to color', () async {
    var value = CustomColors();
    expect(true, CustomColors.getColorFromHex('#222021') != Colors.black54);
    expect(true, CustomColors.getColorFromHex('#222021123121') == Colors.black54);
    expect(true, CustomColors.primaryColor != Colors.black54);
    expect(true, CustomColors.secondaryColor != Colors.black54);
    expect(true, CustomColors.subPrimaryColor != Colors.black54);
    expect(true, CustomColors.colorHighlight != Colors.black54);
    expect(true, CustomColors.inputColor != Colors.black54);
    expect(true, CustomColors.formColor != Colors.black54);
    expect(true, CustomColors.notActive != Colors.black54);
    expect(true, CustomColors.selectedCard != Colors.black54);
    expect(true, CustomColors.selectedCardIcon != Colors.black54);
  });

  test('test validation errors', () async {
    var value = ValidationErrors();
    expect(true, value != null);
  });
}
