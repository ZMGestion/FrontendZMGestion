import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';

class Ciudades extends Models {
  /* -Mysql Model-*/
  final int idCiudad;
  final int idProvincia;
  final String idPais;
  final String ciudad;

  /* -Other-*/

  Ciudades({this.idProvincia, this.idPais, this.ciudad, this.idCiudad});

  @override
  Ciudades fromMap(Map<String, dynamic> mapModel) {
    return Ciudades(
        idCiudad: mapModel["Ciudades"]["IdCiudad"],
        idProvincia: mapModel["Ciudades"]["IdProvincia"],
        idPais: mapModel["Ciudades"]["IdPais"],
        ciudad: mapModel["Ciudades"]["Ciudad"]);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "Ciudades": {
        "IdProvincia": this.idProvincia,
        "IdPais": this.idPais,
        "Ciudad": this.ciudad,
        "IdCiudad": this.idCiudad
      }
    };
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }
}
