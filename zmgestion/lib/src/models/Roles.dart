import 'package:zmgestion/src/models/Models.dart';

class Roles extends Models{
  /* -Mysql Model-*/
  final int       idRol;
  final String    rol;
  final DateTime  fechaAlta;
  final String    descripcion;

  /* -Other-*/

  Roles({
    this.idRol,
    this.rol,
    this.fechaAlta,
    this.descripcion
  });

  @override
  Roles fromMap(Map<String, dynamic> mapModel) {
    return Roles(
      idRol:        mapModel["IdRol"],
      rol:          mapModel["Rol"],
      fechaAlta:    mapModel["FechaAlta"],
      descripcion:  mapModel["Descripcion"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "Roles": {
        "IdRol":        this.idRol,
        "Rol":          this.rol,
        "FechaAlta":    this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "Descripcion":  this.descripcion
      }
    };
  }

}