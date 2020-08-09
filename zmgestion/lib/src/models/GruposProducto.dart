import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class GruposProducto extends Equatable with Models{
  /* -Mysql Model-*/
  final int idGrupoProducto;
  final String grupo;
  final DateTime fechaAlta;
  final DateTime fechaBaja;
  final String estado;
  final String descripcion;

  /* -Other-*/

  GruposProducto({
    this.idGrupoProducto, 
    this.grupo,
    this.fechaAlta,
    this.fechaBaja,
    this.estado,
    this.descripcion
  });

  @override
  List<Object> get props => [idGrupoProducto];

  Map<String, String> mapEstados(){
    return {
      "A": "Activo",
      "B": "Baja"
    };
  }

  @override
  GruposProducto fromMap(Map<String, dynamic> mapModel) {
    return GruposProducto(
        idGrupoProducto:     mapModel["GruposProducto"]["IdGrupoProducto"],
        grupo:       mapModel["GruposProducto"]["Grupo"],
        fechaAlta:      mapModel["GruposProducto"]["FechaAlta"] != null ? DateTime.parse(mapModel["GruposProducto"]["FechaAlta"]) : null,
        fechaBaja:      mapModel["GruposProducto"]["FechaBaja"] != null ? DateTime.parse(mapModel["GruposProducto"]["FechaBaja"]) : null,
        descripcion:  mapModel["GruposProducto"]["Descripcion"],
        estado:         mapModel["GruposProducto"]["Estado"],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> productos = {
      "GruposProducto": {
        "IdGrupoProducto":         this.idGrupoProducto,
        "Grupo":           this.grupo,
        "Estado":         this.estado,
        "FechaAlta":      this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "FechaBaja":      this.fechaBaja != null ? this.fechaBaja.toIso8601String() : null,
        "Descripcion":  this.descripcion
      }
    };


    Map<String, dynamic> result = {};
    result.addAll(productos);

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Text("Not yet");
  }
}
