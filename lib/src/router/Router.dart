import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zmgestion/src/views/HomePage.dart';
import 'package:zmgestion/src/views/clientes/ClientesIndex.dart';
import 'package:zmgestion/src/views/comprobantes/ComprobantesIndex.dart';
import 'package:zmgestion/src/views/domicilios/DomiciliosIndex.dart';
import 'package:zmgestion/src/views/login/Login.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionIndex.dart';
import 'package:zmgestion/src/views/presupuestos/PresupuestosIndex.dart';
import 'package:zmgestion/src/views/productos/ProductosIndex.dart';
import 'package:zmgestion/src/views/productosFinales/ProductosFinalesIndex.dart';
import 'package:zmgestion/src/views/remitos/RemitosIndex.dart';
import 'package:zmgestion/src/views/roles/RolesIndex.dart';
import 'package:zmgestion/src/views/telas/TelasIndex.dart';
import 'package:zmgestion/src/views/ubicaciones/UbicacionesIndex.dart';
import 'package:zmgestion/src/views/usuarios/UsuariosIndex.dart';
import 'package:zmgestion/src/views/ventas/VentasIndex.dart';
import 'package:zmgestion/src/widgets/PdfPreview.dart';

const String InicioRoute = '/inicio';
const String PresupuestosRoute = '/presupuestos';
const String UbicacionesRoute = '/ubicaciones';
const String UsuariosRoute = '/usuarios';
const String ClientesRoute = '/clientes';
const String TelasRoute = '/telas';
const String ProductosRoute = '/productos';
const String ProductosFinalesRoute = '/productos-finales';
const String OrdenesProduccionRoute = '/ordenes-produccion';
const String LoginRoute = '/login';
const String RolesRoute = '/roles';
const String PdfPreview = '/pdf'; //Eliminar despues
const String LoaderRoute = '/';
const String VentasRoute = '/ventas';
const String ComprobantesRoute = '/comprobantes';
const String DomiciliosRoute = '/domicilios';
const String RemitosRoute = '/remitos';

Route<dynamic> generateRoute(RouteSettings settings) {
  var query = settings.name.split('?');
  Map<String, String> queryParameters = {};
  if(query.length > 1){
    query[1].split('&').forEach((queryParam) {
      var values = queryParam.split('=');
      var k = values[0];
      var v;
      if(values.length > 1){
        v = values[1];
      }
      queryParameters.addAll({k: v});
    });
  }

  switch (query[0]) {
    case InicioRoute:
      return _getPageRoute(HomePage(), settings);
    case LoginRoute:
      return _getPageRoute(Login(), settings);
    case PresupuestosRoute:
      return _getPageRoute(PresupuestosIndex(args: queryParameters), settings);
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
    case OrdenesProduccionRoute:
      return _getPageRoute(OrdenesProduccionIndex(), settings);
    case UbicacionesRoute:
      return _getPageRoute(UbicacionesIndex(), settings);
    case RolesRoute:
      return _getPageRoute(RolesIndex(), settings);
    case VentasRoute:
      return _getPageRoute(VentasIndex(args: queryParameters,), settings);
    case PdfPreview:
      return _getPageRoute(PdfIndex(), settings);
    case ComprobantesRoute:
      return _getPageRoute(ComprobantesIndex(args: queryParameters,), settings);
    case DomiciliosRoute:
      return _getPageRoute(DomiciliosIndex(args: queryParameters,), settings);
    case RemitosRoute:
      return _getPageRoute(RemitosIndex(args: queryParameters,), settings);
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
