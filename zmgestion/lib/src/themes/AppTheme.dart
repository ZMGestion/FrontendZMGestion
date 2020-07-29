import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppTheme {
  Light,
  Dark
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    backgroundColor: Color(0xffcbdded),
    scaffoldBackgroundColor: Color(0xffcbdded),
    cardColor: Color(0xffffffff),
    brightness: Brightness.light,
    primaryColor: Color(0xff0066a5),
    primaryColorDark: Color(0xff333333),
    primaryColorLight: Color(0xff0066a5),
    canvasColor: Color(0xfff2f2f2),
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
    cardColor: Color(0xff333333),
    primaryColor: Color(0xff333333),//0xff753434
    primaryColorDark: Color(0xff333333),
    primaryColorLight: Color(0xff0066a5),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(
        color: Color(0xffc14949)
      ),
    )
  ),
};