import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Paises.dart';

class Provincias extends Models {
  /* -Mysql Model-*/
  final int idProvincia;
  final String idPais;
  final String provincia;

  /* -Other-*/
  final Paises pais;

  Provincias({this.idProvincia, this.idPais, this.provincia, this.pais});

  @override
  Provincias fromMap(Map<String, dynamic> mapModel) {
    return Provincias(
        idProvincia: mapModel["Provincias"]["IdProvincia"],
        idPais: mapModel["Provincias"]["IdPais"],
        provincia: mapModel["Provincias"]["Provincia"],
        pais: mapModel["Paises"] != null
            ? Paises().fromMap(mapModel)
            : null);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> provincias = {
      "Provincias": {
        "IdProvincia": this.idProvincia,
        "IdPais": this.idPais,
        "Provincia": this.provincia
      }
    };
    Map<String, dynamic> paises = this.pais?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(provincias);
    result.addAll(paises != null ? paises : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }
}
