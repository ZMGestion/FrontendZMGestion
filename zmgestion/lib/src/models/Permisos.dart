import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';

class Permisos extends Equatable with Models {
  /* -Mysql Model-*/
  final int idPermiso;
  final String permiso;
  final String descripcion;

  /* -Other-*/

  Permisos({this.idPermiso, this.permiso, this.descripcion});
  @override
  List<Object> get props => [idPermiso];

  @override
  Permisos fromMap(Map<String, dynamic> mapModel) {
    return Permisos(
        idPermiso: mapModel["Permisos"]["IdPermiso"],
        permiso: mapModel["Permisos"]["Permiso"],
        descripcion: mapModel["Permisos"]["Descripcion"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "Permisos": {
        "IdPermiso": this.idPermiso,
        "Permiso": this.permiso,
        "Descripcion": this.descripcion
      }
    };
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }
}
