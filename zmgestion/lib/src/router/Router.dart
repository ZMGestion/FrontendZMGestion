import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zmgestion/src/views/HomePage.dart';
import 'package:zmgestion/src/views/clientes/ClientesIndex.dart';
import 'package:zmgestion/src/views/login/Login.dart';
import 'package:zmgestion/src/views/presupuestos/PresupuestosIndex.dart';
import 'package:zmgestion/src/views/productos/ProductosIndex.dart';
import 'package:zmgestion/src/views/productosFinales/ProductosFinalesIndex.dart';
import 'package:zmgestion/src/views/roles/RolesIndex.dart';
import 'package:zmgestion/src/views/telas/TelasIndex.dart';
import 'package:zmgestion/src/views/ubicaciones/UbicacionesIndex.dart';
import 'package:zmgestion/src/views/usuarios/UsuariosIndex.dart';

const String InicioRoute = '/inicio';
const String PresupuestosRoute = '/presupuestos';
const String UbicacionesRoute = '/ubicaciones';
const String UsuariosRoute = '/usuarios';
const String ClientesRoute = '/clientes';
const String TelasRoute = '/telas';
const String ProductosRoute = '/productos';
const String ProductosFinalesRoute = '/productos-finales';
const String LoginRoute = '/login';
const String RolesRoute = '/roles';
const String LoaderRoute = '/';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case InicioRoute:
      return _getPageRoute(HomePage(), settings);
    case LoginRoute:
      return _getPageRoute(Login(), settings);
    case PresupuestosRoute:
      return _getPageRoute(PresupuestosIndex(), settings);
    case UsuariosRoute:
      return _getPageRoute(UsuariosIndex(), settings);
    case ClientesRoute:
      return _getPageRoute(ClientesIndex(), settings);
    case TelasRoute:
      return _getPageRoute(TelasIndex(), settings);
    case ProductosRoute:
      return _getPageRoute(ProductosIndex(), settings);
    case ProductosFinalesRoute:
      return _getPageRoute(ProductosFinalesIndex(), settings);
    case UbicacionesRoute:
      return _getPageRoute(UbicacionesIndex(), settings);
    case RolesRoute:
      return _getPageRoute(RolesIndex(), settings);
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
