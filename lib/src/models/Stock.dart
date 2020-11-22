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

class Stock extends Equatable with Models{
  /* -Mysql Model-*/

  /* -Other-*/
  final Ubicaciones ubicacion;
  final int cantidad;

  Stock({
    this.ubicacion,
    this.cantidad
  });

  @override
  List<Object> get props => [ubicacion.idUbicacion];

  @override
  Stock fromMap(Map<String, dynamic> mapModel) {
    return Stock(
        ubicacion:        mapModel["Ubicaciones"] != null ? Ubicaciones().fromMap(mapModel) : null,
        cantidad:         mapModel["Cantidad"],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {};
    Map<String, dynamic> stock = {
      "Cantidad": this.cantidad
    };
    
    Map<String, dynamic> ubicaciones = this.ubicacion?.toMap();
    result.addAll(stock);
    result.addAll(ubicaciones != null ? ubicaciones : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    SizeConfig().init(context);
    return Text("Not implemented");
  }
}
