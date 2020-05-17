import 'package:flutter/material.dart';

enum AppTheme {
  Light,
  Dark
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xffDD4C43),
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue[700],
  ),
};