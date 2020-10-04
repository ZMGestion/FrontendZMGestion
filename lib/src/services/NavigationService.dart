import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object args}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: args);
  }

  Future<dynamic> navigateToWithReplacement(String routeName, {Object args}) {
    return navigatorKey.currentState.pushReplacementNamed(routeName, arguments: args);
  }
  
  void goBack(){
    return navigatorKey.currentState.pop();
  }
}