import 'package:zmgestion/src/models/Models.dart';

class Domicilios extends Models{
  /* -Mysql Model-*/
  final int       idDomicilio;
  final int       idCiudad;
  final int       idProvincia;
  final String       idPais;
  final String    domicilio;
  final String    codigoPostal;
  final String    fechaAlta;
  final String    observaciones;

  /* -Other-*/

  Domicilios({
    this.idDomicilio,
    this.idCiudad,
    this.idProvincia,
    this.idPais,
    this.domicilio,
    this.codigoPostal,
    this.fechaAlta,
    this.observaciones
  });

  @override
  Domicilios fromMap(Map<String, dynamic> mapModel) {
    return Domicilios(
      idDomicilio:    mapModel["Domicilios"]["IdDomicilio"],
      idCiudad:       mapModel["Domicilios"]["IdCiudad"],
      idProvincia:    mapModel["Domicilios"]["IdProvincia"],
      idPais:         mapModel["Domicilios"]["IdPais"],
      domicilio:      mapModel["Domicilios"]["Domicilio"],
      codigoPostal:   mapModel["Domicilios"]["CodigoPostal"],
      fechaAlta:      mapModel["Domicilios"]["FechaAlta"],
      observaciones:  mapModel["Domicilios"]["Observaciones"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> domicilios = {
      "Domicilios": {
        "IdDomicilio":    this.idDomicilio,
        "IdCiudad":       this.idCiudad,
        "IdProvincia":    this.idProvincia,
        "IdPais":         this.idPais,
        "Domicilio":      this.domicilio,
        "CodigoPostal":   this.codigoPostal,
        "FechaAlta":      this.fechaAlta,
        "Observaciones":  this.observaciones
      }
    };

    Map<String, dynamic> result = {};
    result.addAll(domicilios);

    return result;
  }

}