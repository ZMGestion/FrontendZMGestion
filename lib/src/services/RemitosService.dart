import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/models/Remitos.dart';
import 'package:zmgestion/src/services/Services.dart';

class RemitosService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  RemitosService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
  }

  GetMethodConfiguration dameConfiguration(int idRemito){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Remitos(),
      path: "/remitos/dame",
      payload: {
        "Remitos": {
          "IdRemito": idRemito
        }
      },
      scheduler: scheduler
    );
  }

  @override
  DoMethodConfiguration crearConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El remito se ha creado con éxito"
      ),
      attributes: {
        "Remitos": [
          "IdDomicilio", "IdUsuario", "IdUbicacion", "Tipo" /*COMPLETAR*/
        ]
      }
    );
  }



  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "El remito ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar el remito, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    return Remitos();
  }


  ListMethodConfiguration buscarRemitos(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Remitos(),
      path: "/remitos",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error durante la busqueda"
      )
    );
  }

  

  DoMethodConfiguration cancelar(Map<String, dynamic> payload) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/cancelar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El remito se ha cancelado con éxito"
      )
    );
  }

  DoMethodConfiguration descancelar(Map<String, dynamic> payload) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/descancelar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El remito se ha descancelado con éxito"
      )
    );
  }

  DoMethodConfiguration entregar(Map<String, dynamic> payload) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/entregar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El remito se ha entregado con éxito"
      )
    );
  }

  DoMethodConfiguration pasarACreado(int idRemito) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/pasarACreado",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: {
        "Remitos":{
          "IdRemito": idRemito
        }
      },
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El remito se ha creado con éxito"
      )
    );
  }
  DoMethodConfiguration crearLineaRemitoConfiguration(LineasProducto lineaProducto) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/lineasRemito/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      model: lineaProducto,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de remito se ha creado con éxito"
      ),
      attributes: {
        "LineasProducto": [
          "IdReferencia", "Cantidad", "IdUbicacion"
        ],
        "ProductosFinales": [
          "IdProducto", "IdTela", "IdLustre"
        ],
      }
    );
  }

  DoMethodConfiguration modificarLineaRemitoConfiguration(LineasProducto lineaProducto) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/lineasRemito/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: lineaProducto,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de remito se ha modificado con éxito"
      ),
      attributes: {
        "LineasProducto": [
          "IdLineaProducto", "IdReferencia", "Cantidad", "IdUbicacion"
        ],
        "ProductosFinales": [
          "IdProducto", "IdTela", "IdLustre"
        ],
      }
    );
  }

  DoMethodConfiguration borrarLineaRemitoConfiguration(int idLineaRemito) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/remitos/lineasRemito/borrar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: {
        "LineasProducto":{
          "IdLineaProducto": idLineaRemito
        }
      },
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de remito se ha eliminado con éxito"
      )
    );
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
  DoMethodConfiguration modificaConfiguration() {
    throw UnimplementedError();
  }
}