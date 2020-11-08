import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Comprobantes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/services/Services.dart';

class VentasService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  VentasService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
  }

  GetMethodConfiguration dameConfiguration(int idVenta){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Ventas(),
      path: "/ventas/dame",
      payload: {
        "Ventas": {
          "IdVenta": idVenta
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
      path: "/ventas/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La venta se ha creado con éxito"
      ),
      attributes: {
        "Ventas": [
          "IdCliente", "IdDomicilio", "IdUbicacion", "Observaciones"
        ]
      }
    );
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    // TODO: implement borraConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "La venta ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar la venta, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return Ventas();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El presupuesto ha sido modificado con éxito"
      )
    );
  }

  ListMethodConfiguration buscarVentas(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Ventas(),
      path: "/ventas",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error"
      )
    );
  }

  ListMethodConfiguration dameMultipleConfiguration(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Ventas(),
      path: "/ventas/dameMultiple",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se obtenian las ventas"
      )
    );
  }

  @override
  DoMethodConfiguration crearLineaVentaConfiguration(LineasProducto lineaProducto) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/lineasVenta/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      model: lineaProducto,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de venta se ha creado con éxito"
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

  @override
  DoMethodConfiguration revisarVentaConfiguration(int idVenta) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/revisar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: {
        "Ventas":{
          "IdVenta":idVenta
        }
      },
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La venta ha sido confirmada con éxito"
      )
    );
  }

  @override
  DoMethodConfiguration chequearVentaConfiguration(int idVenta) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/chequearPrecios",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: {
        "Ventas":{
          "IdVenta":idVenta
        }
      },
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true
      )
    );
  }

    @override
  DoMethodConfiguration cancelarVentaConfiguration(int idVenta) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/cancelar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: {
        "Ventas":{
          "IdVenta":idVenta
        }
      },
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La venta ha sido cancelada con éxito"
      )
    );
  }

  @override
  DoMethodConfiguration borrarLineaVentaConfiguration(Map<String, dynamic> payload) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/lineasVenta/borrar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de venta se ha eliminado con éxito"
      )
    );
  }

  @override
  DoMethodConfiguration cancelarLineaVentaConfiguration(Map<String, dynamic> payload) {
    // TODO: implement altaConfiguration
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/lineasVenta/cancelar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de venta se ha cancelado con éxito"
      )
    );
  }

  ListMethodConfiguration buscarComprobantesConfiguration(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      path:"/ventas/comprobantes",
      model: Comprobantes(),
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showLoading: true,
        showError: true,
        errorMessage: "Ha ocurrido un error"
      )
    );
  }

  DoMethodConfiguration crearComprobanteConfiguration(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/comprobantes/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El comprobante se ha creado con éxito"
      ),
    );
  }
  DoMethodConfiguration modificarComprobanteConfiguration(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/comprobantes/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El comprobante se ha modificado con éxito"
      ),
    );
  }
  DoMethodConfiguration darAltaComprobanteConfiguration(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/comprobantes/darAlta",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El comprobante se ha dado de alta con éxito"
      ),
    );
  }

  DoMethodConfiguration darBajaComprobanteConfiguration(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/comprobantes/darBaja",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El comprobante se ha dado de baja con éxito"
      ),
    );
  }
  GetMethodConfiguration dameComprobanteConfiguration(int idComprobante){
    return GetMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/comprobantes/dame",
      authorizationHeader: true,
      model: Comprobantes(),
      scheduler: scheduler,
      payload: {
        "Comprobantes":{
          "IdComprobante": idComprobante
        }
      },
    );
  }
  DoMethodConfiguration borrarComprobanteConfiguration(int idComprobante){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/comprobantes/borrar",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: {
        "Comprobantes":{
          "IdComprobante": idComprobante
        }
      },
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        showError: true,
        successMessage: "El comprobante se ha borrado con éxito",
        errorMessage: "Ha ocurrido un error al intentar borrar el comprobante"
      ),
    );
  }

  DoMethodConfiguration modificarLineaVenta(LineasProducto lineaProducto) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/lineasVenta/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      model: lineaProducto,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "La linea de venta se ha modificado con éxito"
      ),
      attributes: {
        "LineasProducto": [
          "IdLineaProducto", "IdReferencia", "Cantidad", "PrecioUnitario"
        ],
        "ProductosFinales": [
          "IdProducto", "IdTela", "IdLustre"
        ],
      }
    );
  }

  DoMethodConfiguration generarOrdenProduccion(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      path: "/ventas/generarOrdenProduccion",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se generaba la orden de producción",
        successMessage: "La orden de producción se ha creado con éxito"
      )
    );
  }

  DoMethodConfiguration generarRemito(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/generarRemito",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El remito se ha creado con éxito"
      ),
      payload: payload
    );
  }

  DoMethodConfiguration modificarDomicilio(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/ventas/modificarDomicilio",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "Se ha modificar el domicilio con éxito"
      ),
      payload: payload
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

}