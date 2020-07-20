import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/services/Services.dart';

class ProductosService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  ProductosService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
  }


  @override
  DoMethodConfiguration crearConfiguration() {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productos/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El producto se ha creado con éxito"
      ),
      attributes: {
        "Productos": [
          "Producto"
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
      path: "/productos/darAlta",
      authorizationHeader: true,
      requestConfiguration: RequestConfiguration(
        successMessage: "El producto se ha activado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido activar el producto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    // TODO: implement bajaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productos/darBaja",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        successMessage: "El producto se ha dado de baja con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido dar de baja el producto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    // TODO: implement borraConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productos/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "El producto ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar el producto, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return Productos();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productos/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El producto ha sido modificado con éxito"
      )
    );
  }
  
  @override
  DoMethodConfiguration modificaPrecioConfiguration(Productos producto) {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/productos/precios/modificar",
      model: producto,
      attributes: {
        "Productos": ["IdProducto"],
        "Precios": ["Precio"]
      },
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El precio de el producto ha sido modificado con éxito"
      )
    );
  }

  ListMethodConfiguration buscarProductos(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Productos(),
      path: "/productos",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se buscaba el producto"
      )
    );
  }

  ListMethodConfiguration listarPreciosProducto(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Precios(),
      path: "/productos/precios",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se obtenian los precios"
      )
    );
  }

  GetMethodConfiguration dameConfiguration(int idProducto){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Productos(),
      path: "/productos/dame",
      payload: {
        "Productos": {
          "IdProducto": idProducto
        }
      },
      scheduler: scheduler
    );
  }
}