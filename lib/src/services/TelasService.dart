import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/Services.dart';

class TelasService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  TelasService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
  }


  @override
  DoMethodConfiguration crearConfiguration() {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/telas/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La tela se ha creado con éxito"
      ),
      attributes: {
        "Telas": [
          "Tela"
        ],
        "Precios": [
          "Precio"
        ]
      }
    );
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/telas/darAlta",
      authorizationHeader: true,
      requestConfiguration: RequestConfiguration(
        successMessage: "La tela se ha activado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido activar la tela, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    // TODO: implement bajaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/telas/darBaja",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        successMessage: "La tela se ha dado de baja con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido dar de baja la tela, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    // TODO: implement borraConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/telas/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "La tela ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar la tela, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return Telas();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/telas/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La tela ha sido modificado con éxito"
      )
    );
  }
  
  @override
  DoMethodConfiguration modificaPrecioConfiguration(Telas tela) {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/telas/precios/modificar",
      model: tela,
      attributes: {
        "Telas": ["IdTela"],
        "Precios": ["Precio"]
      },
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El precio de la tela ha sido modificado con éxito"
      )
    );
  }

  ListMethodConfiguration buscarTelas(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Telas(),
      path: "/telas",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se buscaba la tela"
      )
    );
  }

  ListMethodConfiguration listarPreciosTela(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Precios(),
      path: "/telas/precios",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se obtenian los precios"
      )
    );
  }

  GetMethodConfiguration dameConfiguration(int idTela){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Telas(),
      path: "/telas/dame",
      payload: {
        "Telas": {
          "IdTela": idTela
        }
      },
      scheduler: scheduler
    );
  }
}