import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';

class Paginaciones with Models{
  final int pagina;
  final int longitudPagina;
  final int cantidadTotal;

  Paginaciones({
    this.pagina, 
    this.longitudPagina,
    this.cantidadTotal
  });

  @override
  fromMap(Map<String, dynamic> mapModel) {
    // TODO: implement fromMap
    return Paginaciones(
      pagina: mapModel["Paginaciones"]["Pagina"],
      longitudPagina: mapModel["Paginaciones"]["LongitudPagina"],
      cantidadTotal: mapModel["Paginaciones"]["CantidadTotal"],
    );
  }
  
  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "Paginaciones":{
        "Pagina": this.pagina,
        "LongitudPagina": this.longitudPagina,
        "CantidadTotal": this.cantidadTotal
      }
    };
  }
  
  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }

}