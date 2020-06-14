import 'package:zmgestion/src/models/Models.dart';

class Roles extends Models{
  /* -Mysql Model-*/
  final int       idRol;
  final String    rol;
  final String  fechaAlta;
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
      idRol:        mapModel["Roles"]["IdRol"],
      rol:          mapModel["Roles"]["Rol"],
      fechaAlta:    mapModel["Roles"]["FechaAlta"],
      descripcion:  mapModel["Roles"]["Descripcion"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "Roles": {
        "IdRol":        this.idRol,
        "Rol":          this.rol,
        "FechaAlta":    this.fechaAlta,
        "Descripcion":  this.descripcion
      }
    };
  }

}