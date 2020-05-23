import 'package:flutter/material.dart';
import 'package:zmgestion/src/views/structure/ZMDrawer.dart';
import 'package:zmgestion/src/widgets/SubCollapsingListTile.dart';

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