import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Models.dart';

class ModelDataSource extends DataTableSource {
  final List<Models> models;
  final List<String> attributes;
  final Map<String, Widget Function(dynamic)> cellBuilder;
  /*
  "Nombres": (value){Text(value)}
  
  */

  ModelDataSource({
    Key key,
    this.models,
    this.attributes,
    this.cellBuilder
  });

  /*void _sort<T>(Comparable<T> Function(Models d) getField, bool ascending) {
    models.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }*/

  int _selectedCount = 0;

  List<DataCell> bindCell(Models model){
    Map<String, dynamic> mapModel = model.getAttributes(attributes);
    List<DataCell> _cells = new List<DataCell>();

    mapModel.forEach((column, value) {
      _cells.add(DataCell(cellBuilder[column](value)));
    });
    
    return _cells;



  }

  @override
  DataRow getRow(int index){
    assert(index >= 0);
    if (index >= models.length) return null;
    final model = models[index];
    return DataRow.byIndex(
      index: index,
      selected: model.selected,
      onSelectChanged: (value) {
        if (model.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          model.selected = value;
          notifyListeners();
        }
      },
      cells: bindCell(model),
    );
  }

  @override
  int get rowCount => models.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    for (final model in models) {
      model.selected = checked;
    }
    _selectedCount = checked ? models.length : 0;
    notifyListeners();
  }
}