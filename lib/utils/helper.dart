import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static String DATE_WITH_TIME = "dd/MM/yyyy HH:mm";
  static String DATE = "dd/MM/yyyy";
  static String TIME = "HH:mm";

  static parseBool(String value) {
    return value.toLowerCase() == 'true';
  }

  static boolToString(bool value) {
    return value ? 'true' : 'false';
  }

  static parseDate(String date) {
    return DateFormat(DATE_WITH_TIME).parse(date);
  }

  static dateToString(DateTime date) {
    return DateFormat(DATE).format(date);
  }

  static getTimeFromDateTime(DateTime dateTime) {
    return TimeOfDay.fromDateTime(dateTime);
  }

  static timeToString(TimeOfDay time) {
    return time.hour.toString() + ":" + time.minute.toString();
  }
}
