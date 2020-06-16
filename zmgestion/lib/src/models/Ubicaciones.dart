import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/Models.dart';

class Ubicaciones extends Models{
  /* -Mysql Model-*/
  final int       idUbicacion;
  final int       idDomicilio;
  final String    ubicacion;
  final String    fechaAlta;
  final String    fechaBaja;
  final String    observaciones;

  /* -Other-*/
  final Domicilios domicilio;

  Ubicaciones({
    this.idUbicacion,
    this.idDomicilio,
    this.ubicacion,
    this.fechaAlta,
    this.fechaBaja,
    this.observaciones,
    this.domicilio
  });

  @override
  Ubicaciones fromMap(Map<String, dynamic> mapModel) {
    return Ubicaciones(
      idUbicacion:      mapModel["Ubicaciones"]["IdUbicacion"],
      idDomicilio:      mapModel["Ubicaciones"]["IdDomicilio"],
      ubicacion:        mapModel["Ubicaciones"]["Ubicacion"],
      fechaAlta:        mapModel["Ubicaciones"]["FechaAlta"],
      fechaBaja:        mapModel["Ubicaciones"]["FechaBaja"],
      observaciones:    mapModel["Ubicaciones"]["Observaciones"],
      domicilio:        mapModel["Domicilios"] != null ? Domicilios().fromMap({"Domicilios": mapModel["Domicilios"]}) : null
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> ubicaciones = {
      "Ubicaciones": {
        "IdUbicacion":    this.idUbicacion,
        "IdDomicilio":    this.idDomicilio,
        "Ubicacion":      this.ubicacion,
        "FechaAlta":      this.fechaAlta,
        "FechaBaja":      this.fechaBaja,
        "Observaciones":  this.observaciones
      }
    };

    Map<String, dynamic> domicilios = this.domicilio?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(ubicaciones);
    result.addAll(domicilios != null ? domicilios : {});

    return result;
  }

}