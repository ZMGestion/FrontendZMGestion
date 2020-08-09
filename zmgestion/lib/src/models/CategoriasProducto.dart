import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class CategoriasProducto extends Equatable with Models{
  /* -Mysql Model-*/
  final int idCategoriaProducto;
  final String categoria;
  final DateTime fechaAlta;
  final String descripcion;

  /* -Other-*/

  CategoriasProducto({
    this.idCategoriaProducto, 
    this.categoria,
    this.fechaAlta,
    this.descripcion
  });

  @override
  List<Object> get props => [idCategoriaProducto];

  @override
  CategoriasProducto fromMap(Map<String, dynamic> mapModel) {
    return CategoriasProducto(
        idCategoriaProducto:     mapModel["CategoriasProducto"]["IdCategoriaProducto"],
        categoria:       mapModel["CategoriasProducto"]["Categoria"],
        fechaAlta:      mapModel["CategoriasProducto"]["FechaAlta"] != null ? DateTime.parse(mapModel["CategoriasProducto"]["FechaAlta"]) : null,
        descripcion:  mapModel["CategoriasProducto"]["Descripcion"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> categorias = {
      "CategoriasProducto": {
        "IdCategoriaProducto":         this.idCategoriaProducto,
        "Categoria":           this.categoria,
        "FechaAlta":      this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "Descripcion":  this.descripcion
      }
    };


    Map<String, dynamic> result = {};
    result.addAll(categorias);

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Text("Not yet");
  }
}
