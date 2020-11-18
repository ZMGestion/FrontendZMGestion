import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/views/telas/CrearTelasAlertDialog.dart';
import 'package:zmgestion/src/views/telas/ModificarTelasAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ModelViewDialog.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMBreadCrumb/ZMBreadCrumbItem.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class TelasIndex extends StatefulWidget {
  @override
  _TelasIndexState createState() => _TelasIndexState();
}

class _TelasIndexState extends State<TelasIndex> {
  Map<int, Telas> telas = {};

  /*ZMTable key*/
  int refreshValue = 0;

  /*Search*/
  String searchText = "";
  String searchIdEstado = "T";
  /*Search filters*/
  bool showFilters = false;
  bool searchByTela = true;
  Map<String, String> breadcrumb = new Map<String, String>();

  @override
  void initState() {
    breadcrumb.addAll({
      "Inicio":"/inicio",
      "Telas": null,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Flexible(
              child: Column(
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ZMBreadCrumb(
                        config: breadcrumb,
                      ),
                    ),
                  ],
                ),
                  Container(
                    height: 90,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Buscar",
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.search),
                                        alignLabelWithHint: true,
                                        contentPadding:
                                            EdgeInsets.fromLTRB(20, 15, 20, 0)),
                                    onChanged: (value) {
                                      setState(() {
                                        searchText = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            /*
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showFilters = !showFilters;
                                });
                              },
                              icon: Icon(
                                FontAwesomeIcons.filter,
                                size: 14,
                                color: showFilters
                                    ? Colors.blueAccent.withOpacity(0.8)
                                    : Theme.of(context)
                                        .iconTheme
                                        .color
                                        .withOpacity(0.7),
                              ),
                            ),
                            */
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                constraints: BoxConstraints(minWidth: 200),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TopLabel(
                                      labelText: "Estado",
                                    ),
                                    Container(
                                      width: 250,
                                      child: DropDownMap(
                                        map: Telas()
                                            .mapEstados(),
                                        addAllOption: true,
                                        addAllText: "Todos",
                                        addAllValue: "T",
                                        initialValue: "T",
                                        onChanged: (value) {
                                          setState(() {
                                            searchIdEstado =
                                                value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: AppLoader(builder: (scheduler) {
                      return ZMTable(
                        key: Key(searchText + searchIdEstado.toString() + searchByTela.toString() + refreshValue.toString()),
                        model: Telas(),
                        service: TelasService(),
                        listMethodConfiguration: TelasService().buscarTelas({
                          "Telas": {
                            "Tela": searchByTela ? searchText : null,
                            "Estado": searchIdEstado
                          }
                        }),
                        pageLength: 12,
                        paginate: true,
                        cellBuilder: {
                          "Telas": {
                            "Tela": (value) {
                              return Text(
                                value.toString(),
                                textAlign: TextAlign.center,
                              );
                            }
                          },
                          "Precios": {
                            "Precio": (value) {
                              return Text(
                                  "\$ "+value.toString(),
                                  textAlign: TextAlign.center);
                            },
                            "FechaAlta": (value){
                              return Text(
                                  Utils.cuteDateTimeText(DateTime.parse(value)),
                                  textAlign: TextAlign.center);
                            },
                          }
                        },
                        tableLabels: {
                          "Precios": {
                            "FechaAlta": "Última actualización"
                          }
                        },
                        fixedActions: [
                          ZMStdButton(
                            color: Colors.green,
                            text: Text(
                              "Crear tela",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierColor: Theme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.5),
                                builder: (BuildContext context) {
                                  return CrearTelasAlertDialog(
                                    title: "Crear Telas",
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        refreshValue = Random().nextInt(99999);
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          )
                        ],
                        onSelectActions: (telas) {
                          bool estadosIguales = true;
                          String estado;
                          if (telas.length >= 1) {
                            Map<String, dynamic> anterior;
                            for (Telas tela in telas) {
                              Map<String, dynamic> mapTela = tela.toMap();
                              if (anterior != null) {
                                if (anterior["Telas"]["Estado"] !=
                                    mapTela["Telas"]["Estado"]) {
                                  estadosIguales = false;
                                }
                              }
                              if (!estadosIguales) break;
                              anterior = mapTela;
                            }
                            if (estadosIguales) {
                              estado = telas[0].toMap()["Telas"]["Estado"];
                            }
                          }
                          return <Widget>[
                            Visibility(
                              visible: estadosIguales && estado != null,
                              child: Row(
                                children: [
                                  ZMStdButton(
                                    color: Colors.white,
                                    text: Text(
                                      (estado == "A"
                                              ? "Dar de baja"
                                              : "Dar de alta") +
                                          " (" +
                                          telas.length.toString() +
                                          ")",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    icon: Icon(
                                      estado == "A"
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color:
                                          estado == "A" ? Colors.red : Colors.green,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierColor: Theme.of(context)
                                            .backgroundColor
                                            .withOpacity(0.5),
                                        builder: (BuildContext context) {
                                          return MultipleRequestView(
                                            models: telas,
                                            title: (estado == "A"
                                                    ? "Dar de baja"
                                                    : "Dar de alta") +
                                                " " +
                                                telas.length.toString() +
                                                " telas",
                                            service: TelasService(),
                                            doMethodConfiguration: estado == "A"
                                                ? TelasService()
                                                    .bajaConfiguration()
                                                : TelasService()
                                                    .altaConfiguration(),
                                            payload: (mapModel) {
                                              return {
                                                "Telas": {
                                                  "IdTela": mapModel["Telas"]["IdTela"]
                                                }
                                              };
                                            },
                                            itemBuilder: (mapModel) {
                                              return Text(mapModel["Telas"]["Tela"]);
                                            },
                                            onFinished: () {
                                              setState(() {
                                                refreshValue =
                                                    Random().nextInt(99999);
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 15,
                                  )
                                ],
                              ),
                            ),
                            ZMStdButton(
                              color: Colors.red,
                              text: Text(
                                "Borrar (" + telas.length.toString() + ")",
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Theme.of(context)
                                      .backgroundColor
                                      .withOpacity(0.5),
                                  builder: (BuildContext context) {
                                    return MultipleRequestView(
                                      models: telas,
                                      title: "Borrar " +
                                          telas.length.toString() +
                                          " telas",
                                      service: TelasService(),
                                      doMethodConfiguration:
                                          TelasService().borraConfiguration(),
                                      payload: (mapModel) {
                                        return {
                                          "Telas": {
                                            "IdTela": mapModel["Telas"]
                                                ["IdTela"]
                                          }
                                        };
                                      },
                                      itemBuilder: (mapModel) {
                                        return Text(mapModel["Telas"]["Tela"]);
                                      },
                                      onFinished: () {
                                        setState(() {
                                          refreshValue = Random().nextInt(99999);
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                            )
                          ];
                        },
                        rowActions: (mapModel, index, itemsController) {
                          Telas tela;
                          String estado = "A";
                          int idTela = 0;
                          if (mapModel != null) {
                            tela = Telas().fromMap(mapModel);
                            if (mapModel["Telas"] != null) {
                              if (mapModel["Telas"]["Estado"] != null) {
                                estado = mapModel["Telas"]["Estado"];
                              }
                              if (mapModel["Telas"]["IdTela"] != null) {
                                idTela = mapModel["Telas"]["IdTela"];
                              }
                            }
                          }
                          return <Widget>[
                            ZMTooltip(
                              message: "Ver precios",
                              visible: idTela != 0,
                              child: IconButtonTableAction(
                                iconData: Icons.show_chart,
                                onPressed: idTela == 0 ? null : () {
                                  if (idTela != 0) {
                                    showDialog(
                                      context: context,
                                      barrierColor: Theme.of(context)
                                          .backgroundColor
                                          .withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return ModelViewDialog(
                                          content: ModelView(
                                            service: TelasService(),
                                            getMethodConfiguration: TelasService()
                                                .dameConfiguration(idTela),
                                            isList: false,
                                            itemBuilder:
                                                (mapModel, index, itemController) {
                                              return Telas()
                                                  .fromMap(mapModel)
                                                  .viewModel(context);
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                              ),
                            ),
                            ZMTooltip(
                              key: Key("EstadoTela"+estado),
                              message: estado == "A" ? "Dar de baja" : "Dar de alta",
                              theme: estado == "A" ? ZMTooltipTheme.RED : ZMTooltipTheme.GREEN,
                              visible: idTela != 0,
                              child: IconButtonTableAction(
                                iconData: (estado == "A"
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward),
                                color: estado == "A" ? Colors.redAccent : Colors.green,
                                onPressed: idTela == 0 ? null : () {
                                  if (idTela != 0) {
                                    if (estado == "A") {
                                      TelasService(scheduler: scheduler).baja({
                                        "Telas": {"IdTela": idTela}
                                      }).then((response) {
                                        if (response.status == RequestStatus.SUCCESS) {
                                          itemsController.add(ItemAction(
                                              event: ItemEvents.Update,
                                              index: index,
                                              updateMethodConfiguration:
                                                  TelasService().dameConfiguration(
                                                      tela.idTela)));
                                        }
                                      });
                                    } else {
                                      TelasService().alta({
                                        "Telas": {"IdTela": idTela}
                                      }).then((response) {
                                        if (response.status == RequestStatus.SUCCESS) {
                                          itemsController.add(ItemAction(
                                              event: ItemEvents.Update,
                                              index: index,
                                              updateMethodConfiguration:
                                                  TelasService().dameConfiguration(
                                                      tela.idTela)));
                                        }
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            ZMTooltip(
                              message: "Modificar",
                              visible: idTela != 0,
                              child: IconButtonTableAction(
                                iconData: Icons.edit,
                                onPressed: idTela == 0 ? null : () {
                                  if (idTela != 0) {
                                    showDialog(
                                      context: context,
                                      barrierColor: Theme.of(context)
                                          .backgroundColor
                                          .withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return ModelView(
                                          service: TelasService(),
                                          getMethodConfiguration: TelasService().dameConfiguration(idTela),
                                          isList: false,
                                          itemBuilder: (updatedMapModel, internalIndex, itemController) => ModificarTelasAlertDialog(
                                            title: "Modificar tela",
                                            tela: Telas().fromMap(updatedMapModel),
                                            onSuccess: () {
                                              Navigator.of(context).pop();
                                              itemsController.add(ItemAction(
                                                  event: ItemEvents.Update,
                                                  index: index,
                                                  updateMethodConfiguration:
                                                      TelasService().dameConfiguration(
                                                          tela.idTela)));
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            ZMTooltip(
                              message: "Borrar",
                              theme: ZMTooltipTheme.RED,
                              visible: idTela != 0,
                              child: IconButtonTableAction(
                                iconData: Icons.delete_outline,
                                onPressed: idTela == 0 ? null : () {
                                  if (idTela != 0) {
                                    showDialog(
                                      context: context,
                                      barrierColor: Theme.of(context)
                                          .backgroundColor
                                          .withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return DeleteAlertDialog(
                                          title: "Borrar tela",
                                          message:
                                              "¿Está seguro que desea eliminar la tela?",
                                          onAccept: () async {
                                            await TelasService().borra({
                                              "Telas": {"IdTela": idTela}
                                            }).then((response) {
                                              if (response.status ==
                                                  RequestStatus.SUCCESS) {
                                                itemsController.add(ItemAction(
                                                    event: ItemEvents.Hide,
                                                    index: index));
                                              }
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            )
                          ];
                        },
                        searchArea: TableTitle(
                          title: "Telas"
                        )
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
