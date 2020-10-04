import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/views/ventas/VentasModelView.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class Comprobantes extends Equatable with Models{
  /* -Mysql Model-*/
  final int idComprobante;
  final int idVenta;
  final int idUsuario;
  final String tipo;
  final int numeroComprobante;
  final double monto;
  final DateTime fechaAlta;
  final DateTime fechaBaja;
  final String observaciones;
  final String estado;

  /* -Other-*/
  final Usuarios usuario;
  final Ventas venta;

  Comprobantes({
    this.idComprobante,
    this.idVenta,
    this.idUsuario,
    this.tipo,
    this.numeroComprobante,
    this.monto,
    this.fechaAlta,
    this.fechaBaja,
    this.observaciones,
    this.estado,
    this.usuario,
    this.venta,
  });

  @override
  List<Object> get props => [idVenta];

  Map<String, String> mapEstados(){
    return {
      "E": "En creación",
      "R": "En revisión",
      "C": "Pendiente",
      "A": "Cancelada",
      "N": "Entregada"
      //Definir como hacer para denotar entregada y cancelada
    };
  }
  Map<String, String> mapTipos(){
    return {
      "A": "Factura A",
      "B": "Factura B",
      "N": "Nota de Crédito A",
      "M": "Nota de Crédito B",
      "R": "Recibo"
      //Definir como hacer para denotar entregada y cancelada
    };
  }

  @override
  Comprobantes fromMap(Map<String, dynamic> mapModel) {
    return Comprobantes(
        idComprobante:          mapModel["Comprobantes"]["IdComprobante"],
        idVenta:                mapModel["Comprobantes"]["IdVenta"],
        idUsuario:              mapModel["Comprobantes"]["IdUsuario"],
        tipo:                   mapModel["Comprobantes"]["Tipo"],
        numeroComprobante:      mapModel["Comprobantes"]["NumeroComprobante"],
        monto:                  mapModel["Comprobantes"]["Monto"],
        fechaAlta:              mapModel["Comprobantes"]["FechaAlta"] != null ? DateTime.parse(mapModel["Comprobantes"]["FechaAlta"]) : null,
        fechaBaja:              mapModel["Comprobantes"]["FechaBaja"] != null ? DateTime.parse(mapModel["Comprobantes"]["FechaAlta"]) : null,
        observaciones:          mapModel["Comprobantes"]["Observaciones"],
        estado:                 mapModel["Comprobantes"]["Estado"],
        usuario:                mapModel["Usuarios"] != null ? Usuarios().fromMap({"Usuarios": mapModel["Usuarios"]}) : null,
        venta:                  mapModel["Ventas"] != null ? Ventas().fromMap(mapModel) : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> comprobantes = {
      "Comprobantes": {
        "IdComprobante":      this.idComprobante,
        "IdVenta":            this.idVenta,
        "IdUsuario":          this.idUsuario,
        "Tipo":               this.tipo,
        "NumeroComprobante":  this.numeroComprobante,
        "Monto":              this.monto,
        "FechaAlta":          this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "FechaBaja":          this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "Observaciones":      this.observaciones,
        "Estado":             this.estado,
      }
    };
    
    Map<String, dynamic> ventas = this.venta?.toMap();
    Map<String, dynamic> usuarios = this.usuario?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(comprobantes);
    result.addAll(ventas != null ? ventas : {});
    result.addAll(usuarios != null ? usuarios : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return AppLoader(
      builder: (scheduler){
        return Container();
      },
    );
  }
}
