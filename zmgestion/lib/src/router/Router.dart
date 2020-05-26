import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zmgestion/src/views/HomePage.dart';
import 'package:zmgestion/src/views/Test.dart';
import 'package:zmgestion/src/views/usuarios/IndexUsuarios.dart';

const String InicioRoute = '/inicio';
const String PresupuestosRoute = '/presupuestos';
const String UsuariosRoute = '/usuarios';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case InicioRoute:
      return _getPageRoute(HomePage(), settings);
    case PresupuestosRoute:
      return _getPageRoute(Test(), settings);
    case UsuariosRoute:
      return _getPageRoute(IndexUsuarios(), settings);
    default:
      return _getPageRoute(HomePage(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}