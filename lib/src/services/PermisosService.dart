import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Permisos.dart';
import 'package:zmgestion/src/services/Services.dart';

class PermisosService extends Services {
  RequestScheduler scheduler;
  BuildContext context;

  PermisosService({RequestScheduler scheduler, BuildContext context}) {
    this.scheduler = scheduler;
    this.context = context;
  }

  @override
  DoMethodConfiguration crearConfiguration() {
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
  DoMethodConfiguration borraConfiguration() {
    throw UnimplementedError();
  }

  @override
  Models getModel() {
    return Permisos();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    throw UnimplementedError();
  }

  ListMethodConfiguration listar() {
    throw UnimplementedError();
  }

   ListMethodConfiguration listarPermisos(Map<String, dynamic> payload) {
    return ListMethodConfiguration(
      method: Methods.POST,
      model: Permisos(),
      authorizationHeader: true,
      path: "/permisos",
      scheduler: scheduler,
      payload: payload
    );
  }
}
