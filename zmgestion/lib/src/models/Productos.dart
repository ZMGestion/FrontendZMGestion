import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/CategoriasProducto.dart';
import 'package:zmgestion/src/models/GruposProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/TiposProductos.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:zmgestion/src/widgets/ZMCharts/ZMPointsLineChart.dart';

class Productos extends Equatable with Models{
  /* -Mysql Model-*/
  final int idProducto;
  final int idGrupoProducto;
  final int idCategoriaProducto;
  final String idTipoProducto;
  final String producto;
  final DateTime fechaAlta;
  final DateTime fechaBaja;
  final String estado;
  final String observaciones;
  final double longitudTela;

  /* -Other-*/
  final Precios precio;
  final GruposProducto grupoProducto;
  final CategoriasProducto categoriaProducto;
  final TiposProducto tipoProducto;

  Productos({
    this.idProducto, 
    this.idGrupoProducto,
    this.idCategoriaProducto,
    this.idTipoProducto,
    this.producto,
    this.fechaAlta,
    this.fechaBaja,
    this.estado,
    this.observaciones,
    this.longitudTela,
    this.precio,
    this.grupoProducto,
    this.categoriaProducto,
    this.tipoProducto
  });

  @override
  List<Object> get props => [idProducto];

  Map<String, String> mapEstados(){
    return {
      "A": "Activo",
      "B": "Baja"
    };
  }

  @override
  Productos fromMap(Map<String, dynamic> mapModel) {
    return Productos(
        idProducto:     mapModel["Productos"]["IdProducto"],
        producto:       mapModel["Productos"]["Producto"],
        fechaAlta:      mapModel["Productos"]["FechaAlta"] != null ? DateTime.parse(mapModel["Productos"]["FechaAlta"]) : null,
        fechaBaja:      mapModel["Productos"]["FechaBaja"] != null ? DateTime.parse(mapModel["Productos"]["FechaBaja"]) : null,
        observaciones:  mapModel["Productos"]["Observaciones"],
        longitudTela: mapModel["Productos"]["LongitudTela"],
        estado:         mapModel["Productos"]["Estado"],
        idGrupoProducto: mapModel["Productos"]["IdGrupoProducto"],
        idCategoriaProducto: mapModel["Productos"]["IdCategoriaProducto"],
        idTipoProducto: mapModel["Productos"]["IdTipoProducto"],
        precio:         mapModel["Precios"] != null ? Precios().fromMap({"Precios": mapModel["Precios"]}) : null,
        grupoProducto:         mapModel["GruposProducto"] != null ? GruposProducto().fromMap({"GruposProducto": mapModel["GruposProducto"]}) : null,
        categoriaProducto:         mapModel["CategoriasProducto"] != null ? CategoriasProducto().fromMap({"CategoriasProducto": mapModel["CategoriasProducto"]}) : null,
        tipoProducto:         mapModel["TiposProducto"] != null ? TiposProducto().fromMap({"TiposProducto": mapModel["TiposProducto"]}) : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> productos = {
      "Productos": {
        "IdProducto":           this.idProducto,
        "IdGrupoProducto":      this.idGrupoProducto,
        "IdCategoriaProducto":  this.idCategoriaProducto,
        "IdTipoProducto":       this.idTipoProducto,
        "Producto":             this.producto,
        "LongitudTela":         this.longitudTela,
        "Estado":               this.estado,
        "FechaAlta":            this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "FechaBaja":            this.fechaBaja != null ? this.fechaBaja.toIso8601String() : null,
        "Observaciones":        this.observaciones
      }
    };

    Map<String, dynamic> precios = this.precio?.toMap();
    Map<String, dynamic> gruposProducto = this.grupoProducto?.toMap();
    Map<String, dynamic> categoriasProducto = this.categoriaProducto?.toMap();
    Map<String, dynamic> tiposProducto = this.tipoProducto?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(productos);
    result.addAll(precios != null ? precios : {});
    result.addAll(gruposProducto != null ? gruposProducto : {});
    result.addAll(categoriasProducto != null ? categoriasProducto : {});
    result.addAll(tiposProducto != null ? tiposProducto : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Column(
      children: [
        AlertDialogTitle(
          title: producto,
          width: SizeConfig.blockSizeHorizontal * 50,
        ),
        Container(
          width: SizeConfig.blockSizeHorizontal * 50,
          height: SizeConfig.blockSizeVertical * 40,
          padding: EdgeInsets.all(20),
          child: ZMPointsLineChart(
            service: ProductosService(),
            listMethodConfiguration: ProductosService().listarPreciosProducto({"Productos":{"IdProducto": idProducto}}),
            domainFn: (mapModel, _){
              Precios precios = Precios().fromMap(mapModel);
              return precios.fechaAlta;
            },
            measureFn: (mapModel, _){
              return mapModel["Precios"]["Precio"];
            },
          ),
        ),
      ],
    );
  }
}
