// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/widgets/ZMTableOld/ModelDataSource.dart';

/*
ZMTableOld(
  source: ModelDataSource(
    labels: ["Identificador","Nombres","Apellidos"]
    attributes: ["IdUsuario","Nombres","Apellidos"],
    models: resultSet,

  )

)

*/

class ZMTableOld extends StatefulWidget {
  final int rowsPerPage;
  final Widget header;
  final Function(bool) onSelectAll;
  final bool sortAscending;
  final Services service;
  final ListMethodConfiguration listMethodConfiguration;
  final Map<String, Map<String,Widget Function(dynamic)>> cellBuilder;

  const ZMTableOld({
    Key key,
    this.rowsPerPage,
    this.onSelectAll,
    this.sortAscending = true,
    this.header,
    this.service,
    this.listMethodConfiguration,
    this.cellBuilder
  }) : super(key: key);

  @override
  _ZMTableOldState createState() => _ZMTableOldState();
}

class _ZMTableOldState extends State<ZMTableOld> {
  int _rowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending;
  ModelDataSource _modelDataSource;
  List<String> _columnNames;
  List<DataColumn> columns = new List<DataColumn>();
  List<Models> models = List<Models>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.service.listMethod(widget.listMethodConfiguration).then(
      (response){
        if(response.status == RequestStatus.SUCCESS){
          setState(() {
            models = response.message;
          });
        }else{
          ScreenMessage.push("No se han podido cargar los usuarios.", MessageType.Error);
        }
      }
    );

    _rowsPerPage = widget.rowsPerPage != null ? widget.rowsPerPage : PaginatedDataTable.defaultRowsPerPage;
    widget.cellBuilder.forEach((parent, mapBuilder){
      mapBuilder.keys.forEach((name) {
        columns.add(
          DataColumn(
            label: Text(name),
            onSort: (columnIndex, ascending){
              return _sort<String>((mapModel) => mapModel[parent][name], columnIndex, ascending);
            }
          )
        );
      });
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _modelDataSource ??= ModelDataSource(
      cellBuilder: widget.cellBuilder,
      models: models
    );
  }

  void _sort<T>(
    Comparable<T> Function(Map<String, dynamic> mapModel) getField,
    int columnIndex,
    bool ascending,
  ) {
    _modelDataSource.sort<T>(getField, ascending);
    setState((){
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(models != null){
      if(models.isNotEmpty){
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
          PaginatedDataTable(
            header: widget.header,
            rowsPerPage: _rowsPerPage,
            onRowsPerPageChanged: (value) {
              setState(() {
                _rowsPerPage = value;
              });
            },
            sortColumnIndex: _sortColumnIndex,
            sortAscending: widget.sortAscending,
            onSelectAll: widget.onSelectAll,
            columns: columns,
            source: ModelDataSource(
              cellBuilder: widget.cellBuilder,
              models: models
            ),
          ),
        ],
        );
      }
    }
    return Container(child: Text("Cargando tablita"),);
  }
}
