import 'dart:async';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Paginaciones.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/widgets/DefaultResultEmpty.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/PageInfoHandler.dart';

/*
  Example cellBuilder:
    cellBuilder: {
      "Usuarios": {
        "Nombres": (value){return Text(value.toString(), textAlign: TextAlign.center,);},
        "Apellidos": (value){return Text(value.toString(), textAlign: TextAlign.center);},
        "Documento": (value){return Text(value.toString(), textAlign: TextAlign.center);},
        "Telefono": (value){return Text(value.toString(), textAlign: TextAlign.center);},
      },
      "Roles": {
        "Rol": (value){return ListView.builder(itemCount: 3, shrinkWrap: true, physics: ClampingScrollPhysics(), scrollDirection: Axis.vertical, itemBuilder: (context, index) => Text(index.toString(), textAlign: TextAlign.center,));}
      }
    }
*/

class ZMTable extends StatefulWidget {
  final Services service;
  final String modelViewKey;
  final Models model;
  final ListMethodConfiguration listMethodConfiguration;
  final Map<String, Map<String, Function(dynamic)>> cellBuilder;
  final Map<String, Map<String, String>> tableLabels;
  final List<Widget> Function(List<Models>) onSelectActions;
  final Color tableBackgroundColor;
  final Widget onEmpty;
  final Widget searchArea;
  final List<Widget> fixedActions;
  final List<Widget> Function(
      Map<String, dynamic>, int index, StreamController<ItemAction>) rowActions;
  final bool paginate;
  final int pageLength;
  final double height;
  final List<Models> initialSelection;
  final bool showCheckbox;
  final Widget Function(List<Models>) bottomAction;
  final EdgeInsets padding;
  final ListMethodConfiguration initialSelectionConfiguration;
  final Services initialService;

  const ZMTable(
      {Key key,
      this.modelViewKey = "",
      this.cellBuilder,
      this.tableLabels,
      this.onSelectActions,
      this.tableBackgroundColor,
      this.onEmpty,
      this.searchArea,
      this.rowActions,
      this.service,
      this.listMethodConfiguration,
      this.model,
      this.fixedActions,
      this.paginate = false,
      this.height = 280,
      this.pageLength = 12,
      this.showCheckbox = false,
      this.initialSelection,
      this.initialSelectionConfiguration,
      this.initialService,
      this.padding = const EdgeInsets.all(12),
      this.bottomAction})
      : super(key: key);

  @override
  _ZMTableState createState() => _ZMTableState();
}

class _ZMTableState extends State<ZMTable> {
  List<Models> models = new List<Models>();

  bool selected = false;

  List<String> columnNames;

  List<Widget> columns = new List<Widget>();

  ListMethodConfiguration paginatedlistMethodConfiguration;
  int pagina = 1;
  int cantidadTotal = 0;
  int longitudPagina = 0;
  Paginaciones pageInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    columnNames = getColumnNames();
    columns = generateColumns(columnNames);
    longitudPagina = widget.pageLength;

    pageInfo = Paginaciones(longitudPagina: widget.pageLength, cantidadTotal: 0, pagina: 1);
    if (widget.paginate) {
      _updatePage(pageInfo);
    } else {
      paginatedlistMethodConfiguration = widget.listMethodConfiguration;
    }

    if (widget.initialService != null && widget.initialSelectionConfiguration != null){
      SchedulerBinding.instance.addPostFrameCallback((_) async{ 
        await widget.initialService.listMethod(widget.initialSelectionConfiguration).then((response){
          if(response.status == RequestStatus.SUCCESS){
            response.message.forEach((model) {
              models.add(model);
            });
          }
        });
      });
    }
    
    

    // if(widget.initialSelection != null){
    //   widget.initialSelection.forEach((element) {
    //     models.add(element);
    //   });
    // }
  }

  _updatePage(Paginaciones pageInfo) {
    if (widget.paginate) {
      setState(() {
        paginatedlistMethodConfiguration = paginatedListMethodConfiguration();
      });
    }
  }

  List<String> getColumnNames() {
    List<String> _result = new List<String>();
    widget.cellBuilder.forEach((parent, columnMap) {
      columnMap.forEach((columnName, builer) {
        var _columnName = columnName;
        if (widget.tableLabels != null) {
          if (widget.tableLabels.containsKey(parent)) {
            if (widget.tableLabels[parent].containsKey(columnName)) {
              _columnName = widget.tableLabels[parent][columnName];
            }
          }
        }
        _result.add(_columnName);
      });
    });
    return _result;
  }

  List<Widget> generateColumns(List<String> columnNames) {
    List<Widget> result = new List<Widget>();
    columnNames.forEach((name) {
      result.add(Expanded(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: <Shadow>[
                Shadow(
                    color: Colors.black38, offset: Offset(0, 1), blurRadius: 2)
              ]),
        ),
      ));
    });
    return result;
  }

  List<Widget> generateRow(Map<String, dynamic> mapModel) {
    List<Widget> columnContent = new List<Widget>();

    widget.cellBuilder.forEach((parent, columnMap) {
      columnMap.forEach((columnName, builder) {
        columnContent
            .add(Expanded(child: builder(mapModel[parent][columnName])));
      });
    });

    return columnContent;
  }

  ListMethodConfiguration paginatedListMethodConfiguration(){
    if(widget.paginate){
      paginatedlistMethodConfiguration = new ListMethodConfiguration(
            path: widget.listMethodConfiguration.path,
            payload: widget.listMethodConfiguration.payload,
            authorizationHeader:
                widget.listMethodConfiguration.authorizationHeader,
            model: widget.listMethodConfiguration.model,
            method: widget.listMethodConfiguration.method,
            scheduler: widget.listMethodConfiguration.scheduler,
            requestConfiguration:
                widget.listMethodConfiguration.requestConfiguration,
            actionsConfiguration:
                widget.listMethodConfiguration.actionsConfiguration,
            paginacion: pageInfo);
    }else{
      paginatedlistMethodConfiguration = widget.listMethodConfiguration;
    }
    return paginatedlistMethodConfiguration;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Table
        Padding(
          padding: widget.padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: widget.searchArea != null
                      ? widget.searchArea
                      : Container()),
              Visibility(
                visible: models.length > 0  && widget.onSelectActions != null,
                child: Card(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Text(
                          models.length.toString() +
                              " seleccionado" +
                              (models.length > 1 ? "s" : ""),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Row(
                          children: widget.onSelectActions != null
                              ? widget.onSelectActions(models)
                              : []
                            )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                padding: EdgeInsets.all(6),
                child: Row(
                  children:
                      widget.fixedActions != null ? widget.fixedActions : [],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Card(
            color: widget.tableBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    Visibility(
                      visible: widget.onSelectActions != null || widget.showCheckbox,
                      child: Opacity(
                        opacity: 0,
                        child: Row(children: [
                          CircularCheckBox(
                            value: false,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            onChanged: (s) {},
                          ),
                          Container(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                " ",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1
                                        .color,
                                    fontWeight: FontWeight.bold),
                              ))
                        ]),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              gradient: RadialGradient(
                                  center: Alignment.bottomCenter,
                                  radius: 15,
                                  colors: [
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.7),
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.6)
                                  ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: columns,
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: Row(
                        children: widget.rowActions != null
                            ? widget.rowActions(null, null, null)
                            : [],
                      ),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Container(
                      height: widget.height,
                      child: ModelView(
                        key: Key(pageInfo.pagina.toString()+widget.modelViewKey),
                        isList: true,
                        service: widget.service,
                        listMethodConfiguration: paginatedListMethodConfiguration(),
                        onEmpty: () {
                          if(widget.onEmpty != null){
                            return widget.onEmpty;
                          }
                          return DefaultResultEmpty();
                        },
                        onPageInfo: (newPageInfo) {
                          if (newPageInfo != null) {
                            setState(() {
                              this.pageInfo = newPageInfo;
                            });
                          }
                        },
                        itemBuilder: (mapModel, index, itemsController) {
                          Models model = widget.model.fromMap(mapModel);
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: models.contains(model)
                                          ? Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText1
                                              .color
                                              .withOpacity(0.5)
                                          : Theme.of(context)
                                              .primaryTextTheme
                                              .bodyText1
                                              .color
                                              .withOpacity(0.3),
                                      width: 1)),
                            ),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: widget.onSelectActions != null || widget.showCheckbox,
                                  child: Row(
                                    children: [
                                      CircularCheckBox(
                                        value: models.contains(model),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.padded,
                                        onChanged: (s) {
                                          setState(() {
                                            models.contains(model)
                                                ? models.remove(model)
                                                : models.add(model);
                                          });
                                          print(models);
                                        },
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: models.contains(model)
                                              ? Theme.of(context).primaryColor.withOpacity(0.3)
                                              : Colors.transparent,
                                        ),
                                        child: Text(
                                          widget.paginate ? (pageInfo.longitudPagina * (pageInfo.pagina - 1) + index + 1).toString() : (index + 1).toString(),
                                          style: TextStyle(
                                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Row(
                                              children: generateRow(mapModel),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: widget.rowActions != null
                                      ? widget.rowActions(
                                          mapModel, index, itemsController)
                                      : [],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                      visible: widget.paginate,
                      child: PageInfoHandler(
                        key: Key(
                          pageInfo.pagina.toString() +
                              pageInfo.cantidadTotal.toString(),
                        ),
                        initialPageInfo: Paginaciones(
                            longitudPagina: widget.pageLength,
                            pagina: pageInfo.pagina,
                            cantidadTotal: pageInfo.cantidadTotal),
                        onChange: (newPageInfo) {
                          setState(() {
                            pageInfo = newPageInfo;
                            _updatePage(pageInfo);
                          });
                        },
                      )
                    ),
                    Visibility(
                      visible: widget.bottomAction != null,
                      child: widget.bottomAction != null ? Padding(
                        padding: const EdgeInsets.only(top:4),
                        child: widget.bottomAction(models),
                      ) : Container(),
                    )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
