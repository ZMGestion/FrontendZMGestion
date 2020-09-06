import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/services/Services.dart';

class PresupuestosService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  PresupuestosService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
  }

  GetMethodConfiguration dameConfiguration(int idProducto){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Presupuestos(),
      path: "/presupuestos/dame",
      payload: {
        "Presupuestos": {
          "IdPresupuesto": idProducto
        }
      },
      scheduler: scheduler
    );
  }

  @override
  DoMethodConfiguration crearConfiguration() {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/presupuestos/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El presupuesto se ha creado con éxito"
      ),
      attributes: {
        "Presupuestos": [
          "IdCliente", "IdUsuario", "IdUbicacion" /*COMPLETAR*/
        ]
      }
    );
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/presupuestos/darAlta",
      authorizationHeader: true,
      requestConfiguration: RequestConfiguration(
        successMessage: "El presupuesto se ha activado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido activar el presupuesto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    // TODO: implement bajaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/presupuestos/darBaja",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        successMessage: "El presupuesto se ha dado de baja con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido dar de baja el presupuesto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    // TODO: implement borraConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/presupuestos/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "El presupuesto ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar el presupuesto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return Presupuestos();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/presupuestos/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El presupuesto ha sido modificado con éxito"
      )
    );
  }

  ListMethodConfiguration buscarPresupuestos(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Presupuestos(),
      path: "/presupuestos",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se buscaba el presupuesto"
      )
    );
  }

  @override
  DoMethodConfiguration crearLineaPrespuesto(LineasProducto lineaProducto) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/presupuestos/lineasPresupuesto/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      model: lineaProducto,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de presupuesto se ha creado con éxito"
      ),
      attributes: {
        "LineasProducto": [
          "IdReferencia", "Cantidad", "PrecioUnitario"
        ],
        "ProductosFinales": [
          "IdProducto", "IdTela", "IdLustre"
        ],
      }
    );
  }
}