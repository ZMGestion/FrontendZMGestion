import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionModelView.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class OrdenesProduccion extends Equatable with Models{
  /* -Mysql Model-*/
  final int idOrdenProduccion;
  final int idUsuario;
  final int idVenta;
  final DateTime fechaAlta;
  final String observaciones;
  final String estado;

  /* -Other-*/
  final double precioTotal;
  final List<LineasProducto> lineasProducto;
  final Usuarios usuario;

  OrdenesProduccion({
    this.idOrdenProduccion,
    this.idVenta,
    this.idUsuario,
    this.fechaAlta,
    this.observaciones,
    this.estado,
    this.lineasProducto,
    this.usuario,
    this.precioTotal,
  });

  @override
  List<Object> get props => [idOrdenProduccion];

  Map<String, String> mapEstados(){
    return {
      "E": "En creación",
      "P": "Pendiente",
      "R": "En producción",
      "C": "Cancelada",
      "V": "Verificada"
    };
  }

  @override
  OrdenesProduccion fromMap(Map<String, dynamic> mapModel) {
    List<LineasProducto> _lineasProducto = new List<LineasProducto>();
    if (mapModel["LineasOrdenProduccion"] != null){
      mapModel["LineasOrdenProduccion"].forEach((lineaOrdenProduccion){
        LineasProducto _lineaProducto = LineasProducto().fromMap(lineaOrdenProduccion);
        _lineasProducto.add(_lineaProducto);
      });
    }
    return OrdenesProduccion(
        idOrdenProduccion:  mapModel["OrdenesProduccion"]["IdOrdenProduccion"],
        idVenta:        mapModel["OrdenesProduccion"]["IdVenta"],
        idUsuario:      mapModel["OrdenesProduccion"]["IdUsuario"],
        fechaAlta:      mapModel["OrdenesProduccion"]["FechaAlta"] != null ? DateTime.parse(mapModel["OrdenesProduccion"]["FechaAlta"]) : null,
        observaciones:  mapModel["OrdenesProduccion"]["Observaciones"],
        estado:         mapModel["OrdenesProduccion"]["Estado"],
        precioTotal:      mapModel["OrdenesProduccion"]["_PrecioTotal"],
        usuario:        mapModel["Usuarios"] != null ? Usuarios().fromMap({"Usuarios": mapModel["Usuarios"]}) : null,
        lineasProducto: _lineasProducto,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> ordenesProduccion = {
      "OrdenesProduccion": {
        "IdOrdenProduccion":    this.idOrdenProduccion,
        "IdVenta":          this.idVenta,
        "IdUsuario":        this.idUsuario,
        "FechaAlta":        this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "Observaciones":    this.observaciones,
        "Estado":           this.estado,
        "_PrecioTotal":      this.precioTotal
      }
    };

    Map<String, List<Map<String,dynamic>>> lineasOrdenProduccion = new Map<String, List<Map<String,dynamic>>>();
    if (this.lineasProducto != null){
      lineasOrdenProduccion = {
        "LineasOrdenProduccion": [],
      };
      lineasProducto.forEach((lineaProducto) {
        lineasOrdenProduccion["LineasOrdenProduccion"].add(lineaProducto.toMap());
      });
    }
    
    Map<String, dynamic> usuarios = this.usuario?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(ordenesProduccion);
    result.addAll(lineasOrdenProduccion);
    result.addAll(usuarios != null ? usuarios : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    return OrdenesProduccionModelView(
      context: context,
      ordenProduccion: this,
    );
  }
}
