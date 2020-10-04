import 'dart:html';

import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Permisos.dart';
import 'package:zmgestion/src/models/Roles.dart';
import 'package:zmgestion/src/services/Services.dart';

class RolesService extends Services {
  RequestScheduler scheduler;
  BuildContext context;

  RolesService({RequestScheduler scheduler, BuildContext context}) {
    this.scheduler = scheduler;
    this.context = context;
  }

  @override
  DoMethodConfiguration crearConfiguration() {
    // TODO: implement crearConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/roles/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      attributes: {
        "Roles": [
          "Rol",
          "Descripcion"
        ]
      },
    );
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    // TODO: implement altaConfiguration
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    // TODO: implement bajaConfiguration
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    // TODO: implement borraConfiguration
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/roles/borrar",
        authorizationHeader: true,
        payload: payload,
        requestConfiguration: RequestConfiguration(
            successMessage: "El rol ha sido eliminado con éxito",
            showSuccess: true,
            errorMessage:
                "No se ha podido eliminar el rol, intentelo nuevamente más tarde",
            showError: true));
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return Roles();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/roles/modificar",
        authorizationHeader: true,
        scheduler: scheduler,
        requestConfiguration: RequestConfiguration(
            showSuccess: false,
            showLoading: true,
            successMessage: "El rol ha sido modificado con éxito"));
  }

  ListMethodConfiguration listar() {
    return ListMethodConfiguration(
      method: Methods.GET,
      model: Roles(),
      path: "/roles",
      scheduler: scheduler,
    );
  }

  ListMethodConfiguration listarPermisosConfiguration(
      Map<String, dynamic> payload) {
    return ListMethodConfiguration(
        method: Methods.POST,
        model: Permisos(),
        path: "/roles/permisos",
        scheduler: scheduler,
        payload: payload);
  }

  DoMethodConfiguration asignarPermisosConfiguration(Map<String, dynamic> payload){
    return DoMethodConfiguration(
        method: Methods.POST,
        authorizationHeader: true,
        path: "/roles/asignarPermisos",
        scheduler: scheduler,
        payload: payload,
        requestConfiguration: RequestConfiguration(
          showError: true,
          showSuccess: true,
          successMessage: "Se han asignado los permisos correctamente"
        )
    );
  }
}
