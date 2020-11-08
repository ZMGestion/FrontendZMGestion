import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Lustres.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/views/productosFinales/ProductosFinalesModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class ProductosFinales extends Equatable with Models{
  /* -Mysql Model-*/
  final int idProducto;
  final int idProductoFinal;
  final int idTela;
  final int idLustre;
  final DateTime fechaAlta;
  final DateTime fechaBaja;
  final String estado;

  /* -Other-*/
  final double precioTotal;
  final Productos producto;
  final Telas tela;
  final Lustres lustre;
  final int cantidad;

  ProductosFinales({
    this.idProducto,
    this.idProductoFinal,
    this.idTela,
    this.idLustre,
    this.fechaAlta,
    this.fechaBaja,
    this.estado,
    this.precioTotal,
    this.tela,
    this.lustre,
    this.producto,
    this.cantidad
  });

  @override
  List<Object> get props => [idProductoFinal];

  Map<String, String> mapEstados(){
    return {
      "A": "Activo",
      "B": "Baja"
    };
  }

  @override
  ProductosFinales fromMap(Map<String, dynamic> mapModel) {
    return ProductosFinales(
        idProductoFinal:  mapModel["ProductosFinales"]["IdProductoFinal"],
        idProducto:       mapModel["ProductosFinales"]["IdProducto"],
        idTela:           mapModel["ProductosFinales"]["IdTela"],
        idLustre:         mapModel["ProductosFinales"]["IdLustre"],
        estado:           mapModel["ProductosFinales"]["Estado"],
        fechaAlta:        mapModel["ProductosFinales"]["FechaAlta"] != null ? DateTime.parse(mapModel["ProductosFinales"]["FechaAlta"]) : null,
        fechaBaja:        mapModel["ProductosFinales"]["FechaBaja"] != null ? DateTime.parse(mapModel["ProductosFinales"]["FechaBaja"]) : null,
        precioTotal:      mapModel["ProductosFinales"]["_PrecioTotal"],
        cantidad:         mapModel["ProductosFinales"]["_Cantidad"],
        tela:             mapModel["Telas"] != null ? Telas().fromMap({"Telas": mapModel["Telas"]}) : null,
        lustre:           mapModel["Lustres"] != null ? Lustres().fromMap({"Lustres": mapModel["Lustres"]}) : null,
        producto:         mapModel["Productos"] != null ? Productos().fromMap({"Productos": mapModel["Productos"]}) : null
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> productosFinales = {
      "ProductosFinales": {
        "IdProducto":       this.idProducto,
        "IdProductoFinal":  this.idProductoFinal,
        "IdTela":           this.idTela,
        "IdLustre":         this.idLustre,
        "FechaAlta":        this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "FechaBaja":        this.fechaBaja != null ? this.fechaBaja.toIso8601String() : null,
        "Estado":           this.estado,
        "_PrecioTotal":     this.precioTotal,
        "_Cantidad":        this.cantidad
      }
    };

    Map<String, dynamic> telas = this.tela?.toMap();
    Map<String, dynamic> lustres = this.lustre?.toMap();
    Map<String, dynamic> productos = this.producto?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(productosFinales);
    result.addAll(telas != null ? telas : {});
    result.addAll(lustres != null ? lustres : {});
    result.addAll(productos != null ? productos : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    SizeConfig().init(context);
    return ProductosFinalesModelView(
      productoFinal: this,
    );
  }
}
