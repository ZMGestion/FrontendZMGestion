import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';

class LineasProducto extends Equatable with Models{
  /* -Mysql Model-*/
  final int idLineaProducto;
  final int idLineaProductoPadre;
  final int idProductoFinal;
  final int idUbicacion;
  final int idReferencia;
  final String tipo;
  final double precioUnitario;
  final int cantidad;
  final DateTime fechaAlta;
  final DateTime fechaCancelacion;
  final String estado;

  /* -Other-*/
  final double precioUnitarioActual;
  final ProductosFinales productoFinal;

  LineasProducto({
    this.idLineaProducto,
    this.idLineaProductoPadre,
    this.idProductoFinal,
    this.idUbicacion,
    this.idReferencia,
    this.tipo,
    this.precioUnitario,
    this.cantidad,
    this.fechaAlta,
    this.fechaCancelacion,
    this.estado,
    this.precioUnitarioActual,
    this.productoFinal
  });

   @override
  List<Object> get props => [idLineaProducto];
  
  Map<String, String> mapEstados(){
    // P:Pendiente - C:Cancelada - R:Reservada - O:Produciendo - D:Pendiente de entrega - E:Entregada
    return {
      "P": "Pendiente",
      "C": "Cancelada",
      "R": "Reservada",
      "D": "Pendiente de entrega",
      "U": "Utilizada en venta",
      "N": "No utilizada",
      "E": "Entregada"
    };
  }

  @override
  LineasProducto fromMap(Map<String,dynamic> mapModel) {
      // TODO: implement fromMap
      return LineasProducto(
        idLineaProducto: mapModel["LineasProducto"]["IdLineaProducto"],
        idLineaProductoPadre: mapModel["LineasProducto"]["IdLineaProductoPadre"],
        idProductoFinal: mapModel["LineasProducto"]["IdProductoFinal"],
        idUbicacion: mapModel["LineasProducto"]["IdUbicacion"],
        idReferencia: mapModel["LineasProducto"]["IdReferencia"],
        tipo: mapModel["LineasProducto"]["Tipo"],
        precioUnitario: mapModel["LineasProducto"]["PrecioUnitario"],
        cantidad: mapModel["LineasProducto"]["Cantidad"],
        fechaAlta:  mapModel["LineasProducto"]["FechaAlta"] != null ? DateTime.parse(mapModel["LineasProducto"]["FechaAlta"]) : null,
        fechaCancelacion:  mapModel["LineasProducto"]["FechaCancelacion"] != null ? DateTime.parse(mapModel["LineasProducto"]["FechaCancelacion"]) : null,
        estado: mapModel["LineasProducto"]["Estado"],
        productoFinal: mapModel["ProductosFinales"] != null ? ProductosFinales().fromMap(mapModel) : null,
        precioUnitarioActual: mapModel["LineasProducto"]["_PrecioUnitarioActual"]
      );
    }
  
    @override
    Map<String, dynamic> toMap() {
      // TODO: implement toMap
      Map<String, dynamic> lineasProducto = {
        "LineasProducto":{
          "IdLineaProducto":      this.idLineaProducto,
          "IdLineaProductoPadre": this.idLineaProductoPadre,
          "IdProductoFinal":      this.idProductoFinal,
          "IdUbicacion":          this.idUbicacion,
          "IdReferencia":         this.idReferencia,
          "Tipo":                 this.tipo,
          "PrecioUnitario":       this.precioUnitario,
          "Cantidad":             this.cantidad,
          "FechaAlta":            this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
          "FechaCancelacion":     this.fechaCancelacion!= null ? this.fechaCancelacion.toIso8601String() : null,
          "Estado":               this.estado,
          "_PrecioUnitarioActual": this.precioUnitarioActual
        }
      };
      
      Map<String, dynamic> productosFinales = this.productoFinal?.toMap();
      Map<String, dynamic> result = {};

      result.addAll(lineasProducto);
      result.addAll(productosFinales != null ? productosFinales : {});

      return result;
    }
  
    @override
    Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }

}