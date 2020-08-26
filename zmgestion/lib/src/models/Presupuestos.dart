import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class Presupuestos extends Equatable with Models{
  /* -Mysql Model-*/
  final int idPresupuesto;
  final int idCliente;
  final int idVenta;
  final int idUbicacion;
  final int idUsuario;
  final DateTime fechaAlta;
  final String observaciones;
  final String estado;

  /* -Other-*/
  final List<LineasProducto> lineasProducto;

  Presupuestos({
    this.idPresupuesto,
    this.idCliente,
    this.idVenta,
    this.idUbicacion,
    this.idUsuario,
    this.fechaAlta,
    this.observaciones,
    this.estado,
    this.lineasProducto
  });

  @override
  List<Object> get props => [idPresupuesto];

  Map<String, String> mapEstados(){
    return {
      "E": "En creacion",
      "C": "Creado",
      "X": "Expirado",
      "V": "Vendido"
    };
  }

  @override
  Presupuestos fromMap(Map<String, dynamic> mapModel) {
    List<LineasProducto> _lineasProducto = new List<LineasProducto>();
    if (mapModel["LineasPresupuesto"] != null){
      mapModel["LineasPresupuesto"].forEach((lineaPresupuesto){
        LineasProducto _lineaProducto = LineasProducto().fromMap(lineaPresupuesto);
        _lineasProducto.add(_lineaProducto);
      });
    }
    return Presupuestos(
        idPresupuesto:  mapModel["Presupuestos"]["IdPresupuesto"],
        idCliente:      mapModel["Presupuestos"]["IdCliente"],
        idVenta:        mapModel["Presupuestos"]["IdVenta"],
        idUbicacion:    mapModel["Presupuestos"]["IdUbicacion"],
        idUsuario:      mapModel["Presupuestos"]["IdUsuario"],
        fechaAlta:      mapModel["Presupuestos"]["FechaAlta"] != null ? DateTime.parse(mapModel["ProductosFinales"]["FechaAlta"]) : null,
        observaciones:  mapModel["Presupuestos"]["Observaciones"],
        estado:         mapModel["Presupuestos"]["Estado"],
        lineasProducto: _lineasProducto
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> presupuestos = {
      "Presupuestos": {
        "IdPresupuesto":    this.idPresupuesto,
        "IdCliente":        this.idCliente,
        "IdVenta":          this.idVenta,
        "IdUbicacion":      this.idUbicacion,
        "IdUsuario":        this.idUsuario,
        "FechaAlta":        this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "Observaciones":    this.observaciones,
        "Estado":           this.estado,
      }
    };
    Map<String, List<Map<String,dynamic>>> lineasPresupuesto = new Map<String, List<Map<String,dynamic>>>();
    if (this.lineasProducto != null){
      lineasPresupuesto = {
        "LineasPresupuesto":[],
      };
      lineasProducto.forEach((lineaProducto) {
        lineasPresupuesto["LineasPresupuesto"].add(lineaProducto.toMap());
      });
    }

    Map<String, dynamic> result = {};
    result.addAll(presupuestos);
    result.addAll(lineasPresupuesto);

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Text("Nothing yet");
  }
}
