import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static const String dateWithTime = "dd/MM/yyyy HH:mm";
  static const String date = "dd/MM/yyyy";

  static parseBool(String value) {
    return value.toLowerCase() == 'true';
  }

  static boolToString(bool value) {
    return value ? 'true' : 'false';
  }

  static parseDate(String date) {
    return DateFormat(dateWithTime).parse(date);
  }

  static dateToString(DateTime dateTime) {
    return DateFormat(date).format(dateTime);
  }

  static fullDateToString(DateTime date) {
    return DateFormat(dateWithTime).format(date);
  }

  static getTimeFromDateTime(DateTime dateTime) {
    return TimeOfDay.fromDateTime(dateTime);
  }

  static timeToString(TimeOfDay time) {
    return time.hour.toString() + ":" + time.minute.toString();
  }

  static getDiffFromToday(String date) {
    var now = DateTime.now();
    var compare = parseDate(date);
    return compare.difference(now).inDays;
  }

  static String capitalizeString(String s) {
    var str = s.toLowerCase().trim();
    return (str.isNotEmpty ? str[0].toUpperCase() : "") +
        (str.length > 1 ? str.substring(1) : "");
  }
}
