import 'package:flutter/material.dart';

List<TextStyle> commonTextStyles = [
  TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w200,
      color: Colors.white,
      fontFamily: 'Josefin Slab'),
  TextStyle(
      fontSize: 15,
      color: Colors.white,
      fontFamily: 'Josefin Slab',
      fontWeight: FontWeight.w200),
  TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      fontFamily: 'Comfortaa'),
];

TextStyle textStyle(Color color, double fontSize, FontWeight fontWeight) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: 'Comfortaa');
}
