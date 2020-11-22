import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/views/ventas/VentasModelView.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class Ventas extends Equatable with Models{
  /* -Mysql Model-*/
  final int idVenta;
  final int idCliente;
  final int idDomicilio;
  final int idUbicacion;
  final int idUsuario;
  final DateTime fechaAlta;
  final String observaciones;
  final String estado;

  /* -Other-*/
  final double precioTotal;
  final double facturado;
  final double pagado;
  final List<LineasProducto> lineasProducto;
  final Clientes cliente;
  final Usuarios usuario;
  final Ubicaciones ubicacion;
  final Domicilios domicilio;

  Ventas({
    this.idVenta,
    this.idCliente,
    this.idDomicilio,
    this.idUbicacion,
    this.idUsuario,
    this.fechaAlta,
    this.observaciones,
    this.estado,
    this.lineasProducto,
    this.cliente, 
    this.usuario, 
    this.ubicacion,
    this.domicilio,
    this.precioTotal,
    this.facturado,
    this.pagado
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

  @override
  Ventas fromMap(Map<String, dynamic> mapModel) {
    List<LineasProducto> _lineasProducto = new List<LineasProducto>();
    if (mapModel["LineasVenta"] != null){
      mapModel["LineasVenta"].forEach((lineaPresupuesto){
        LineasProducto _lineaProducto = LineasProducto().fromMap(lineaPresupuesto);
        _lineasProducto.add(_lineaProducto);
      });
    }
    
    return Ventas(
        idVenta:        mapModel["Ventas"]["IdVenta"],
        idCliente:      mapModel["Ventas"]["IdCliente"],
        idDomicilio:    mapModel["Ventas"]["IdDomicilio"],
        idUbicacion:    mapModel["Ventas"]["IdUbicacion"],
        idUsuario:      mapModel["Ventas"]["IdUsuario"],
        fechaAlta:      mapModel["Ventas"]["FechaAlta"] != null ? DateTime.parse(mapModel["Ventas"]["FechaAlta"]) : null,
        observaciones:  mapModel["Ventas"]["Observaciones"],
        estado:         mapModel["Ventas"]["Estado"],
        precioTotal:    mapModel["Ventas"]["_PrecioTotal"] != null ? mapModel["Ventas"]["_PrecioTotal"] : 0.00,
        facturado:      mapModel["Ventas"]["_Facturado"] != null ? mapModel["Ventas"]["_Facturado"] : 0.00,
        pagado:         mapModel["Ventas"]["_Pagado"] != null ? mapModel["Ventas"]["_Pagado"] : 0.00,
        cliente:        mapModel["Clientes"] != null ? Clientes().fromMap({"Clientes": mapModel["Clientes"]}) : null,
        usuario:        mapModel["Usuarios"] != null ? Usuarios().fromMap({"Usuarios": mapModel["Usuarios"]}) : null,
        ubicacion:      mapModel["Ubicaciones"] != null ? Ubicaciones().fromMap(mapModel) : null,
        domicilio:      mapModel["Domicilios"] != null? Domicilios().fromMap(mapModel): null,
        lineasProducto: _lineasProducto,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> presupuestos = {
      "Ventas": {
        "IdVenta":          this.idVenta,
        "IdCliente":        this.idCliente,
        "IdDomicilio":      this.idDomicilio,
        "IdUbicacion":      this.idUbicacion,
        "IdUsuario":        this.idUsuario,
        "FechaAlta":        this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "Observaciones":    this.observaciones,
        "Estado":           this.estado,
        "_PrecioTotal":     this.precioTotal,
        "_Facturado":       this.facturado,
        "_Pagado":          this.pagado
      }
    };

    Map<String, List<Map<String,dynamic>>> lineasPresupuesto = new Map<String, List<Map<String,dynamic>>>();
    if (this.lineasProducto != null){
      lineasPresupuesto = {
        "LineasVenta": [],
      };
      lineasProducto.forEach((lineaProducto) {
        lineasPresupuesto["LineasVenta"].add(lineaProducto.toMap());
      });
    }
    
    Map<String, dynamic> clientes = this.cliente?.toMap();
    Map<String, dynamic> usuarios = this.usuario?.toMap();
    Map<String, dynamic> ubicaciones = this.ubicacion?.toMap();
    Map<String, dynamic> domicilios = this.domicilio?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(presupuestos);
    result.addAll(lineasPresupuesto);
    result.addAll(clientes != null ? clientes : {});
    result.addAll(usuarios != null ? usuarios : {});
    result.addAll(ubicaciones != null ? ubicaciones : {});
    result.addAll(domicilios != null ? domicilios : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return AppLoader(
      builder: (scheduler){
        return VentasModelView(
          context: context,
          scheduler: scheduler,
          venta: this,
        );
      },
    );
  }
}
