import 'package:flutter/material.dart';



class FontWeightManager {
  static const FontWeight medium = FontWeight.w600;
  static const FontWeight regular = FontWeight.w500;
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
  double fontSize =16,
  FontWeight fontWeight = FontWeightManager.bold,
  Color color = Colors.black,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontWeight: fontWeight,
    color: color,
    fontSize: fontSize,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}

TextStyle getBlack({
  double fontSize =16,
  FontWeight fontWeight = FontWeightManager.black,
  Color color = Colors.black,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontWeight: fontWeight,
    color: color,
    fontSize: fontSize,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}

TextStyle getRegular({
  double fontSize =16,
  double   letterSpacin= 1,
  FontStyle? fontStyle,
  FontWeight fontWeight = FontWeightManager.regular,
  Color color = Colors.black,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    letterSpacing: letterSpacin,
    fontWeight:fontWeight,
    fontStyle: fontStyle,
    color: color,
    fontSize: fontSize,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}

TextStyle getMedium({
  double fontSize =16,
  FontWeight fontWeight = FontWeightManager.bold,
  Color color = Colors.black,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontWeight: fontWeight,
    color: color,
    fontSize: fontSize,
    overflow: overflow,
    decoration: decoration,
    fontFamily: "PingAR",
  );
}