import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';

class Paises extends Models {
  /* -Mysql Model-*/
  final String idPais;
  final String pais;

  /* -Other-*/

  Paises({this.idPais, this.pais});

  @override
  Paises fromMap(Map<String, dynamic> mapModel) {
    return Paises(
        idPais: mapModel["Paises"]["IdPais"], pais: mapModel["Paises"]["Pais"]);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "Paises": {"IdPais": this.idPais, "Pais": this.pais}
    };
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }
}
