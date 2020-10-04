import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/services/Services.dart';

class UbicacionesService extends Services {
  RequestScheduler scheduler;
  BuildContext context;

  UbicacionesService({RequestScheduler scheduler, BuildContext context}) {
    this.scheduler = scheduler;
    this.context = context;
  }

  @override
  DoMethodConfiguration crearConfiguration() {
    // TODO: implement crearConfiguration
    throw UnimplementedError();
  }

  DoMethodConfiguration crearUbicacionConfiguration(
      Map<String, dynamic> payload) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/ubicaciones/crear",
        authorizationHeader: true,
        scheduler: scheduler,
        requestConfiguration: RequestConfiguration(
            showSuccess: true,
            showLoading: true,
            successMessage: "La ubicación se ha creado con éxito"),
        payload: payload);
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/ubicaciones/darAlta",
        authorizationHeader: true,
        requestConfiguration: RequestConfiguration(
            successMessage: "La ubicación se ha activado con éxito",
            showSuccess: true,
            errorMessage:
                "No se ha podido activar La ubicación, intentelo nuevamente más tarde",
            showError: true));
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    // TODO: implement bajaConfiguration
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/ubicaciones/darBaja",
        authorizationHeader: true,
        scheduler: scheduler,
        requestConfiguration: RequestConfiguration(
            successMessage: "La ubicación se ha dado de baja con éxito",
            showSuccess: true,
            errorMessage:
                "No se ha podido dar de baja La ubicación, intentelo nuevamente más tarde",
            showError: true));
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    // TODO: implement borraConfiguration
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/ubicaciones/borrar",
        authorizationHeader: true,
        payload: payload,
        requestConfiguration: RequestConfiguration(
            successMessage: "La ubicación ha sido eliminada con éxito",
            showSuccess: true,
            errorMessage:
                "No se ha podido eliminar la ubicación, intentelo nuevamente más tarde",
            showError: true));
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return Ubicaciones();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    throw UnimplementedError();
  }

  ListMethodConfiguration listar() {
    return ListMethodConfiguration(
        method: Methods.GET,
        model: Ubicaciones(),
        path: "/ubicaciones",
        scheduler: scheduler);
  }

  GetMethodConfiguration dameConfiguration(int idUbicacion) {
    return GetMethodConfiguration(
        method: Methods.POST,
        authorizationHeader: true,
        model: Ubicaciones(),
        path: "/ubicaciones/dame",
        payload: {
          "Ubicaciones": {"IdUbicacion": idUbicacion}
        },
        scheduler: scheduler);
  }
}
