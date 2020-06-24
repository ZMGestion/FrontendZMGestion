import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Roles.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';

class Usuarios extends Equatable with Models{
  /* -Mysql Model-*/
  final int       idUsuario;
  final int       idRol;
  final int       idUbicacion;
  final int       idTipoDocumento;
  final String    documento;
  final String    nombres;
  final String    apellidos;
  final String    estadoCivil;
  final String    telefono; 
  final String    email;
  final int       cantidadHijos;
  final String    usuario;
  final String    password;
  final String    token;
  final DateTime  fechaUltIntento;
  final int       intentos;
  final DateTime  fechaNacimiento;
  final DateTime  fechaInicio;
  final DateTime  fechaAlta;
  final DateTime  fechaBaja;
  final String    estado;

  /* -Other-*/
  Roles rol;
  Ubicaciones ubicacion;

  Usuarios({
    this.idUsuario,
    this.idRol,
    this.idUbicacion,
    this.idTipoDocumento,
    this.documento,
    this.nombres,
    this.apellidos,
    this.estadoCivil,
    this.telefono, 
    this.email,
    this.cantidadHijos,
    this.usuario,
    this.password,
    this.token,
    this.fechaUltIntento,
    this.intentos,
    this.fechaNacimiento,
    this.fechaInicio,
    this.fechaAlta,
    this.fechaBaja,
    this.estado,
    this.rol,
    this.ubicacion
  });

  @override
  List<Object> get props => [idUsuario];

  Map<String, String> mapEstadosCivil(){
    return {
      "C": "Casado",
      "S": "Soltero",
      "D": "Divorciado"
    };
  }

  @override
  fromMap(Map<String, dynamic> mapModel) {
    return Usuarios(
      idUsuario:        mapModel["Usuarios"]["IdUsuario"],
      idRol:            mapModel["Usuarios"]["IdRol"],
      idUbicacion:      mapModel["Usuarios"]["IdUbicacion"],
      idTipoDocumento:  mapModel["Usuarios"]["IdTipoDocumento"],
      documento:        mapModel["Usuarios"]["Documento"],
      nombres:          mapModel["Usuarios"]["Nombres"],
      apellidos:        mapModel["Usuarios"]["Apellidos"],
      estadoCivil:      mapModel["Usuarios"]["EstadoCivil"],
      telefono:         mapModel["Usuarios"]["Telefono"],
      email:            mapModel["Usuarios"]["Email"],
      cantidadHijos:    mapModel["Usuarios"]["CantidadHijos"],
      usuario:          mapModel["Usuarios"]["Usuario"],
      password:         mapModel["Usuarios"]["Password"],
      token:            mapModel["Usuarios"]["Token"],
      fechaUltIntento:  mapModel["Usuarios"]["FechaUltIntento"] != null ? DateTime.parse(mapModel["Usuarios"]["FechaUltIntento"]) : null,
      intentos:         mapModel["Usuarios"]["Intentos"],
      fechaNacimiento:  mapModel["Usuarios"]["FechaNacimiento"] != null ? DateTime.parse(mapModel["Usuarios"]["FechaNacimiento"]) : null,
      fechaInicio:      mapModel["Usuarios"]["FechaInicio"] != null ? DateTime.parse(mapModel["Usuarios"]["FechaInicio"]) : null,
      fechaAlta:        mapModel["Usuarios"]["FechaAlta"] != null ? DateTime.parse(mapModel["Usuarios"]["FechaAlta"]) : null,
      fechaBaja:        mapModel["Usuarios"]["FechaBaja"] != null ? DateTime.parse(mapModel["Usuarios"]["FechaBaja"]) : null,
      estado:           mapModel["Usuarios"]["Estado"],
      rol:              mapModel["Roles"] != null ? Roles().fromMap({"Roles": mapModel["Roles"]}) : null,
      ubicacion:        mapModel["Ubicaciones"] != null ? Ubicaciones().fromMap({"Ubicaciones": mapModel["Ubicaciones"]}) : null
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    
     Map<String, dynamic> usuarios = {
      "Usuarios": {
        "IdUsuario":        this.idUsuario,
        "IdRol":            this.idRol,
        "IdUbicacion":      this.idUbicacion,
        "IdTipoDocumento":  this.idTipoDocumento,
        "Documento":        this.documento,
        "Nombres":          this.nombres,
        "Apellidos":        this.apellidos,
        "EstadoCivil":      this.estadoCivil,
        "Telefono":         this.telefono,
        "Email":            this.email,
        "CantidadHijos":    this.cantidadHijos,
        "Usuario":          this.usuario,
        "Password":         this.password,
        "Token":            this.token,
        "FechaUltIntento":  this.fechaUltIntento != null ? this.fechaUltIntento.toIso8601String() : null,
        "Intentos":         this.intentos,
        "FechaNacimiento":  this.fechaNacimiento != null ? this.fechaNacimiento.toIso8601String() : null,
        "FechaInicio":      this.fechaInicio != null ? this.fechaInicio.toIso8601String() : null,
        "FechaAlta":        this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "FechaBaja":        this.fechaBaja != null ? this.fechaBaja.toIso8601String() : null,
        "Estado":           this.estado,
      }
    };


    Map<String, dynamic> roles = this.rol?.toMap();
    Map<String, dynamic> ubicaciones = this.ubicacion?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(usuarios);
    result.addAll(roles != null ? roles : {});
    result.addAll(ubicaciones != null ? ubicaciones : {});

    return result;
  }

}