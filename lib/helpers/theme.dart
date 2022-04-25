import 'package:flutter/material.dart';

class CustomColors {
  static Color primaryColor = getColorFromHex('#222021');
  static Color secondaryColor = getColorFromHex('#FF6F61');
  static Color subPrimaryColor = getColorFromHex('#353233');
  static Color colorHighlight = getColorFromHex('#C62368');
  static Color inputColor = getColorFromHex('#757575');
  static Color formColor = getColorFromHex('#DFCDFF');
  static Color notActive = getColorFromHex('#9E9E9E');
  static Color selectedCard = getColorFromHex('#F2EBFF');
  static Color selectedCardIcon = getColorFromHex('#3700B3');

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      var color = Color(int.parse("0x$hexColor"));
      return color;
    }
    return Colors.black54;
  }
}
