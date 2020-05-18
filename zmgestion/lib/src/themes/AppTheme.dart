import 'package:flutter/material.dart';

enum AppTheme {
  Light,
  Dark
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xffC5615B),
    primaryTextTheme: TextTheme(
      bodyText1: TextStyle(
        color: Color(0xff222222)
      ),
      headline6: TextStyle(
        color: Color(0xfff7f7f7)
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Color(0xff222222)
      ),
      headline6: TextStyle(
        color: Color(0xfff7f7f7)
      ),
    )
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xff733B38),
  ),
};