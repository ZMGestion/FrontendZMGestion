import 'package:flutter/material.dart';

enum AppTheme {
  Light,
  Dark
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    backgroundColor: Color(0xffffffff),
    scaffoldBackgroundColor: Color(0xffffffff),
    brightness: Brightness.light,
    primaryColor: Color(0xffB34741),
    primaryTextTheme: TextTheme(
      bodyText1: TextStyle(
        color: Color(0xff222222)
      ),
      caption: TextStyle(
        color: Color(0xffffffff)
      ),
      headline1: TextStyle(
        color: Color(0xffB34741)
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
    backgroundColor: Color(0xff222222),
    scaffoldBackgroundColor: Color(0xff222222),
    brightness: Brightness.dark,
    primaryColor: Color(0xff333333),//0xff753434
    primaryTextTheme: TextTheme(
      headline1: TextStyle(
        color: Color(0xffc14949)
      ),
    )
  ),
};