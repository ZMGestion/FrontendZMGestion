import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Provincias.dart';

class Ciudades extends Models {
  /* -Mysql Model-*/
  final int idCiudad;
  final int idProvincia;
  final String idPais;
  final String ciudad;

  /* -Other-*/
  final Provincias provincia;

  Ciudades(
      {this.idProvincia,
      this.idPais,
      this.ciudad,
      this.idCiudad,
      this.provincia});

  @override
  Ciudades fromMap(Map<String, dynamic> mapModel) {
    return Ciudades(
        idCiudad: mapModel["Ciudades"]["IdCiudad"],
        idProvincia: mapModel["Ciudades"]["IdProvincia"],
        idPais: mapModel["Ciudades"]["IdPais"],
        ciudad: mapModel["Ciudades"]["Ciudad"],
        provincia: mapModel["Provincias"] != null
            ? Provincias().fromMap({"Provincias": mapModel["Provincias"]})
            : null);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> ciudades = {
      "Ciudades": {
        "IdProvincia": this.idProvincia,
        "IdPais": this.idPais,
        "Ciudad": this.ciudad,
        "IdCiudad": this.idCiudad
      }
    };
    Map<String, dynamic> provincias = this.provincia?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(ciudades);
    result.addAll(provincias != null ? provincias : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }
}
