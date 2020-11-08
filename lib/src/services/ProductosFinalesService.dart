import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/CategoriasProducto.dart';
import 'package:zmgestion/src/models/Lustres.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/TiposProductos.dart';
import 'package:zmgestion/src/services/Services.dart';

class ProductosFinalesService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  ProductosFinalesService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
  }


  @override
  DoMethodConfiguration crearConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productosFinales/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El mueble se ha creado con éxito"
      ),
      attributes: {
        "ProductosFinales": [
          "IdProducto", "IdLustre", "IdTela"
        ]
      }
    );
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productosFinales/darAlta",
      authorizationHeader: true,
      requestConfiguration: RequestConfiguration(
        successMessage: "El mueble se ha activado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido activar el mueble, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    // TODO: implement bajaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productosFinales/darBaja",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        successMessage: "El mueble se ha dado de baja con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido dar de baja el mueble, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    // TODO: implement borraConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productosFinales/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "El mueble ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar el mueble, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return ProductosFinales();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productosFinales/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El mueble ha sido modificado con éxito"
      )
    );
  }

  ListMethodConfiguration buscarProductos(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: ProductosFinales(),
      path: "/productosFinales",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se buscaba el mueble"
      )
    );
  }

  ListMethodConfiguration listarLustres(){
    return ListMethodConfiguration(
      method: Methods.GET,
      authorizationHeader: true,
      model: Lustres(),
      path: "/productosFinales/lustres",
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se obtenian los lustres"
      )
    );
  }

  GetMethodConfiguration dameConfiguration(int idProductoFinal){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: ProductosFinales(),
      path: "/productosFinales/dame",
      payload: {
        "ProductosFinales": {
          "IdProductoFinal": idProductoFinal
        }
      },
      scheduler: scheduler
    );
  }

  DoMethodConfiguration dameStock(Map<String, dynamic> payload){
    return DoMethodConfiguration(
          method: Methods.POST,
          path: "/productosFinales/stock",
          authorizationHeader: true,
          scheduler: scheduler,
          payload: payload,
          requestConfiguration: RequestConfiguration(
            showLoading: true,
          )
    );
  }
}