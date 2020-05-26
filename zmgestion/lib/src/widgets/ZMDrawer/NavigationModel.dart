import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  double size;
  IconData icon;
  AnimatedBuilder animatedBuilder;
  NavigationModel({
    this.title,
    this.size,
    this.icon,
    this.animatedBuilder
  });
}