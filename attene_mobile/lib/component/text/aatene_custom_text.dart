import 'package:flutter/material.dart';

class FontWeightManager {
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight black = FontWeight.w800;
  static const FontWeight bold = FontWeight.w700;
}

TextStyle getCustomTextStyle({
   double fontSize =16,
   FontWeight fontWeight = FontWeightManager.regular,
  Color color = Colors.black,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}

TextStyle getBold({
  required Color color,
  required double fontSize,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontWeight: FontWeightManager.bold,
    color: color,
    fontSize: fontSize,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}

TextStyle getBlack({
  required Color color,
  required double fontSize,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontWeight: FontWeightManager.black,
    color: color,
    fontSize: fontSize,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}

TextStyle getRegular({
  required Color color,
  required double fontSize,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontWeight: FontWeightManager.regular,
    color: color,
    fontSize: fontSize,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}

TextStyle getMedium({
  required Color color,
  required double fontSize,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontWeight: FontWeightManager.medium,
    color: color,
    fontSize: fontSize,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}
