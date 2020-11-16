import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/views/remitos/RemitosModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class Remitos extends Equatable with Models{
  /* -Mysql Model-*/
  final int idRemito;
  final int idUbicacion;
  final int idUsuario;
  final String tipo;
  final DateTime fechaAlta;
  final DateTime fechaEntrega;
  final String observaciones;
  final String estado;

  /* -Other-*/
  final List<LineasProducto> lineasProducto;
  final Domicilios domicilio;
  final Usuarios usuario;
  final Ubicaciones ubicacion;
  final Ventas venta;

  Remitos({
    this.idRemito,
    this.idUbicacion,
    this.idUsuario,
    this.tipo,
    this.fechaAlta,
    this.fechaEntrega,
    this.observaciones, 
    this.estado, 
    this.lineasProducto, 
    this.domicilio,
    this.usuario, 
    this.ubicacion,
    this.venta,
    });

  @override
  List<Object> get props => [idRemito];

  Map<String, String> mapEstados(){
    return {
      "E": "En creación",
      "C": "Creado",
      "B": "Cancelado",
      "N": "Entregado"
    };
  }
  Map<String, String> mapTipos(){
    return {
      "E": "Entrada",
      "S": "Salida",
      "X": "Transformacion Entrada",
      "Y": "Transformacion Salida"
    };
  }

  @override
  Remitos fromMap(Map<String, dynamic> mapModel) {
    List<LineasProducto> _lineasProducto = new List<LineasProducto>();
    if (mapModel["LineasRemito"] != null){
      mapModel["LineasRemito"].forEach((lineaRemito){
        LineasProducto _lineaProducto = LineasProducto().fromMap(lineaRemito);
        _lineasProducto.add(_lineaProducto);
      });
    }
    return Remitos(
        idRemito:         mapModel["Remitos"]["IdRemito"],
        idUbicacion:      mapModel["Remitos"]["IdUbicacion"],
        idUsuario:        mapModel["Remitos"]["IdUsuario"],
        tipo:             mapModel["Remitos"]["Tipo"],
        fechaEntrega:     mapModel["Remitos"]["FechaEntrega"] != null ? DateTime.parse(mapModel["Remitos"]["FechaEntrega"]) : null,
        fechaAlta:        mapModel["Remitos"]["FechaAlta"] != null ? DateTime.parse(mapModel["Remitos"]["FechaAlta"]) : null,
        observaciones:    mapModel["Remitos"]["Observaciones"],
        estado:           mapModel["Remitos"]["Estado"],
        domicilio:        mapModel["Domicilios"] != null ? Domicilios().fromMap(mapModel) : null,
        usuario:          mapModel["Usuarios"] != null ? Usuarios().fromMap(mapModel) : null,
        ubicacion:        mapModel["Ubicaciones"] != null ? Ubicaciones().fromMap(mapModel) : null,
        venta:            mapModel["Remitos"]["_Extra"] != null ? Ventas().fromMap(mapModel["Remitos"]["_Extra"]) : null,
        lineasProducto:   _lineasProducto,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> remitos = {
      "Remitos": {
        "IdRemito":         this.idRemito,
        "IdUbicacion":      this.idUbicacion,
        "IdUsuario":        this.idUsuario,
        "Tipo":             this.tipo,
        "FechaEntrega":     this.fechaEntrega != null ? this.fechaEntrega.toIso8601String() : null,
        "FechaAlta":        this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "Observaciones":    this.observaciones,
        "Estado":           this.estado,
        "_Extra":           this.venta != null ? this.venta.toMap() : null
      }
    };

    Map<String, List<Map<String,dynamic>>> lineasRemito = new Map<String, List<Map<String,dynamic>>>();
    if (this.lineasProducto != null){
      lineasRemito = {
        "LineasRemito": [],
      };
      lineasProducto.forEach((lineaProducto) {
        lineasRemito["LineasRemito"].add(lineaProducto.toMap());
      });
    }
    
    Map<String, dynamic> usuarios = this.usuario?.toMap();
    Map<String, dynamic> ubicaciones = this.ubicacion?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(remitos);
    result.addAll(lineasRemito);
    result.addAll(usuarios != null ? usuarios : {});
    result.addAll(ubicaciones != null ? ubicaciones : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    SizeConfig().init(context);
    return RemitosModelView(
      remito: this,
      context: context,
    );
  }
}
