import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';

class Provincias extends Models {
  /* -Mysql Model-*/
  final int idProvincia;
  final String idPais;
  final String provincia;

  /* -Other-*/

  Provincias({this.idProvincia, this.idPais, this.provincia});

  @override
  Provincias fromMap(Map<String, dynamic> mapModel) {
    return Provincias(
        idProvincia: mapModel["Provincias"]["IdProvincia"],
        idPais: mapModel["Provincias"]["IdPais"],
        provincia: mapModel["Provincias"]["Provincia"]);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "Provincias": {
        "IdProvincia": this.idProvincia,
        "IdPais": this.idPais,
        "Provincia": this.provincia
      }
    };
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }
}
