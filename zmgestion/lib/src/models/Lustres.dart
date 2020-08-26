import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class Lustres extends Equatable with Models{
  /* -Mysql Model-*/
  final int idLustre;
  final String lustre;
  final String observaciones;

  Lustres({
    this.idLustre, 
    this.lustre,
    this.observaciones
  });

  @override
  List<Object> get props => [idLustre];

  @override
  Lustres fromMap(Map<String, dynamic> mapModel) {
    return Lustres(
        idLustre:         mapModel["Lustres"]["IdLustre"],
        lustre:           mapModel["Lustres"]["Lustre"],
        observaciones:    mapModel["Lustres"]["Observaciones"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> telas = {
      "Lustres": {
        "IdLustre":       this.idLustre,
        "Lustre":         this.lustre,
        "Observaciones":  this.observaciones
      }
    };

    Map<String, dynamic> result = {};
    result.addAll(telas);

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Text(">>>Tela<<<");
  }
}
