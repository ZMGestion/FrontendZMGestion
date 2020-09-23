import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Roles.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class Clientes extends Equatable with Models {
  /* -Mysql Model-*/
  final int idCliente;
  final String idPais;
  final int idTipoDocumento;
  final String documento;
  final String tipo;
  final String nombres;
  final String apellidos;
  final String razonSocial;
  final String telefono;
  final String email;
  final DateTime fechaNacimiento;
  final DateTime fechaAlta;
  final DateTime fechaBaja;
  final String estado;

  /* -Other-*/
  Roles rol;
  final Domicilios domicilio;

  Clientes(
      {this.idCliente,
      this.idPais,
      this.idTipoDocumento,
      this.documento,
      this.tipo,
      this.nombres,
      this.apellidos,
      this.razonSocial,
      this.telefono,
      this.email,
      this.fechaNacimiento,
      this.fechaAlta,
      this.fechaBaja,
      this.estado, 
      this.domicilio});

  @override
  List<Object> get props => [idCliente];

  Map<String, String> mapEstados() {
    return {"A": "Activo", "B": "Baja"};
  }

  Map<String, String> mapTipo() {
    return {"F": "Física", "J": "Jurídica"};
  }

  @override
  fromMap(Map<String, dynamic> mapModel) {
    return Clientes(
        idCliente: mapModel["Clientes"]["IdCliente"],
        idPais: mapModel["Clientes"]["IdPais"],
        idTipoDocumento: mapModel["Clientes"]["IdTipoDocumento"],
        documento: mapModel["Clientes"]["Documento"],
        tipo: mapModel["Clientes"]["Tipo"],
        nombres: mapModel["Clientes"]["Nombres"],
        apellidos: mapModel["Clientes"]["Apellidos"],
        razonSocial: mapModel["Clientes"]["RazonSocial"],
        telefono: mapModel["Clientes"]["Telefono"],
        email: mapModel["Clientes"]["Email"],
        fechaNacimiento: mapModel["Clientes"]["FechaNacimiento"] != null
            ? DateTime.parse(mapModel["Clientes"]["FechaNacimiento"])
            : null,
        fechaAlta: mapModel["Clientes"]["FechaAlta"] != null
            ? DateTime.parse(mapModel["Clientes"]["FechaAlta"])
            : null,
        fechaBaja: mapModel["Clientes"]["FechaBaja"] != null
            ? DateTime.parse(mapModel["Clientes"]["FechaBaja"])
            : null,
        estado: mapModel["Clientes"]["Estado"],
        domicilio: mapModel["Domicilios"] != null ? Domicilios().fromMap(mapModel) : null
      );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap

    Map<String, dynamic> clientes = {
      "Clientes": {
        "IdCliente": this.idCliente,
        "IdPais": this.idPais,
        "IdTipoDocumento": this.idTipoDocumento,
        "Documento": this.documento,
        "Tipo": this.tipo,
        "Nombres": this.nombres,
        "Apellidos": this.apellidos,
        "RazonSocial": this.razonSocial,
        "Telefono": this.telefono,
        "Email": this.email,
        "FechaNacimiento": this.fechaNacimiento != null
            ? this.fechaNacimiento.toIso8601String()
            : null,
        "FechaAlta":
            this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "FechaBaja":
            this.fechaBaja != null ? this.fechaBaja.toIso8601String() : null,
        "Estado": this.estado,
      }
    };
    Map<String, dynamic> domicilios = this.domicilio?.toMap();
    Map<String, dynamic> result = {};
    result.addAll(domicilios != null ? domicilios :{});
    result.addAll(clientes);

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Column(
      children: [
        Container(
          width: SizeConfig.blockSizeHorizontal * 50,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Text(this.nombres != null ? this.nombres : "..."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
