// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/widgets/ZMTable/ModelDataSource.dart';

/*
ZMTable(
  source: ModelDataSource(
    labels: ["Identificador","Nombres","Apellidos"]
    attributes: ["IdUsuario","Nombres","Apellidos"],
    models: resultSet,

  )

)

*/

class ZMTable extends StatefulWidget {
  final int rowsPerPage;
  final Widget header;
  final ModelDataSource source;
  final Function(bool) onSelectAll;
  final bool sortAscending;

  const ZMTable({
    Key key,
    this.rowsPerPage,
    this.source,
    this.onSelectAll,
    this.sortAscending = true,
    this.header
  }) : super(key: key);

  @override
  _ZMTableState createState() => _ZMTableState();
}

class _ZMTableState extends State<ZMTable> {
  int _rowsPerPage;
  //int _sortColumnIndex;
  ModelDataSource _modelDataSource;
  List<String> _columnNames;
  List<DataColumn> columns = new List<DataColumn>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("A");
    _rowsPerPage = widget.rowsPerPage != null ? widget.rowsPerPage : PaginatedDataTable.defaultRowsPerPage;
    _columnNames = widget.source.attributes;
    _columnNames.forEach((name){
      columns.add(
        DataColumn(
          label: Text(name)
        )
      );
    });
  }
  /*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _modelDataSource ??= ModelDataSource(
      /*attributes: attributes,
      models: models*/
    );
  }
  */

  /*void _sort<T>(
    Comparable<T> Function(Models m) getField,
    int columnIndex,
    bool ascending,
  ) {
    _modelDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }*/

  @override
  Widget build(BuildContext context) {
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
          //sortColumnIndex: _sortColumnIndex,
          sortAscending: widget.sortAscending,
          onSelectAll: widget.onSelectAll,
          columns: columns,
          source: widget.source,
        ),
      ],
    );
  }
}
