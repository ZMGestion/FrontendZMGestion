import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';

class TiposDocumento extends Models{
  /* -Mysql Model-*/
  final int         idTipoDocumento;
  final String      tipoDocumento;
  final String      descripcion;

  /* -Other-*/

  TiposDocumento({
    this.idTipoDocumento,
    this.tipoDocumento,
    this.descripcion
  });

  @override
  TiposDocumento fromMap(Map<String, dynamic> mapModel) {
    return TiposDocumento(
      idTipoDocumento:    mapModel["TiposDocumento"]["IdTipoDocumento"],
      tipoDocumento:      mapModel["TiposDocumento"]["TipoDocumento"],
      descripcion:        mapModel["TiposDocumento"]["Descripcion"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "TiposDocumento": {
        "IdTipoDocumento":    this.idTipoDocumento,
        "TipoDocumento":      this.tipoDocumento,
        "Descripcion":        this.descripcion
      }
    };
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }

}