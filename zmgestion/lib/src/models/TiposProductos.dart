import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class TiposProducto extends Equatable with Models{
  /* -Mysql Model-*/
  final String idTipoProducto;
  final String tipoProducto;
  final String descripcion;

  /* -Other-*/

  TiposProducto({
    this.idTipoProducto, 
    this.tipoProducto,
    this.descripcion
  });

  @override
  List<Object> get props => [idTipoProducto];

  @override
  TiposProducto fromMap(Map<String, dynamic> mapModel) {
    return TiposProducto(
        idTipoProducto:     mapModel["TiposProducto"]["IdTipoProducto"],
        tipoProducto:       mapModel["TiposProducto"]["TipoProducto"],
        descripcion:  mapModel["TiposProducto"]["Descripcion"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> tipoProductos = {
      "TiposProducto": {
        "IdTipoProducto":         this.idTipoProducto,
        "TipoProducto":           this.tipoProducto,
        "Descripcion":  this.descripcion
      }
    };


    Map<String, dynamic> result = {};
    result.addAll(tipoProductos);

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Text("Not yet");
  }
}
