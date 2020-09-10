import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
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
  final double precioTotal;
  final List<LineasProducto> lineasProducto;
  final Clientes cliente;
  final Usuarios usuario;
  final Ubicaciones ubicacion;

  Presupuestos({
    this.idPresupuesto,
    this.idCliente,
    this.idVenta,
    this.idUbicacion,
    this.idUsuario,
    this.fechaAlta,
    this.observaciones,
    this.estado,
    this.lineasProducto,
    this.cliente, 
    this.usuario, 
    this.ubicacion,
    this.precioTotal,
  });

  @override
  List<Object> get props => [idPresupuesto];

  Map<String, String> mapEstados(){
    return {
      "E": "En creación",
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
        fechaAlta:      mapModel["Presupuestos"]["FechaAlta"] != null ? DateTime.parse(mapModel["Presupuestos"]["FechaAlta"]) : null,
        observaciones:  mapModel["Presupuestos"]["Observaciones"],
        estado:         mapModel["Presupuestos"]["Estado"],
        precioTotal:      mapModel["Presupuestos"]["_PrecioTotal"],
        cliente:        mapModel["Clientes"] != null ? Clientes().fromMap({"Clientes": mapModel["Clientes"]}) : null,
        usuario:        mapModel["Usuarios"] != null ? Usuarios().fromMap({"Usuarios": mapModel["Usuarios"]}) : null,
        ubicacion:      mapModel["Ubicaciones"] != null ? Ubicaciones().fromMap({"Ubicaciones": mapModel["Ubicaciones"]}) : null,
        lineasProducto: _lineasProducto,
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
        "_PrecioTotal":      this.precioTotal
      }
    };

    Map<String, List<Map<String,dynamic>>> lineasPresupuesto = new Map<String, List<Map<String,dynamic>>>();
    if (this.lineasProducto != null){
      lineasPresupuesto = {
        "LineasPresupuesto": [],
      };
      lineasProducto.forEach((lineaProducto) {
        lineasPresupuesto["LineasPresupuesto"].add(lineaProducto.toMap());
      });
    }
    
    Map<String, dynamic> clientes = this.cliente?.toMap();
    Map<String, dynamic> usuarios = this.usuario?.toMap();
    Map<String, dynamic> ubicaciones = this.ubicacion?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(presupuestos);
    result.addAll(lineasPresupuesto);
    result.addAll(clientes != null ? clientes : {});
    result.addAll(usuarios != null ? usuarios : {});
    result.addAll(ubicaciones != null ? ubicaciones : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Text("Nothing yet");
  }
}
