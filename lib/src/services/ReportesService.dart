import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/Services.dart';

class ReportesService extends Services {
  RequestScheduler scheduler;
  BuildContext context;

  ReportesService({RequestScheduler scheduler, BuildContext context}) {
    this.scheduler = scheduler;
    this.context = context;
  }

  @override
  DoMethodConfiguration crearConfiguration() {
    throw UnimplementedError();
  }

  DoMethodConfiguration crearUbicacionConfiguration(Map<String, dynamic> payload) {
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    throw UnimplementedError();
  }

  @override
  Models getModel() {
    return null;
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    throw UnimplementedError();
  }

  ListMethodConfiguration stockMuebles() {
    return ListMethodConfiguration(
      method: Methods.GET,
      authorizationHeader: true,
      model: ProductosFinales(),
      path: "/reportes/stock",
      scheduler: scheduler
    );
  }

  ListMethodConfiguration listaPreciosProductos() {
    return ListMethodConfiguration(
      method: Methods.GET,
      authorizationHeader: true,
      model: Productos(),
      path: "/reportes/listaPreciosProductos",
      scheduler: scheduler
    );
  }

  ListMethodConfiguration listaPreciosTelas() {
    return ListMethodConfiguration(
      method: Methods.GET,
      authorizationHeader: true,
      model: Telas(),
      path: "/reportes/listaPreciosTelas",
      scheduler: scheduler
    );
  }
}
