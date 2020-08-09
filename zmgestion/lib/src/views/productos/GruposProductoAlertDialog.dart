import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/GruposProducto.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/GruposProductoService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class GruposProductoAlertDialog extends StatefulWidget {
  final String title;
  final Function() onChange;

  GruposProductoAlertDialog({
    this.title, 
    this.onChange
  });

  @override
  _GruposProductoAlertDialogState createState() =>
      _GruposProductoAlertDialogState();
}

class _GruposProductoAlertDialogState extends State<GruposProductoAlertDialog> {

  final _domicilioFormKey = GlobalKey<FormState>();

  bool showForm;
  String idPaisDireccion;
  int idProvincia;
  int idCiudad;

  String searchText = "";
  String searchEstado = "T";

  final TextEditingController direccionController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showForm = false;
    idPaisDireccion = "AR";
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(builder: (scheduler) {
      return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(0),
          buttonPadding: EdgeInsets.all(0),
          elevation: 1.5,
          scrollable: true,
          backgroundColor: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: AlertDialogTitle(
            title: widget.title, 
            titleColor: Theme.of(context).canvasColor,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              height: SizeConfig.blockSizeVertical * 60,
              width: SizeConfig.blockSizeHorizontal * 75,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(24))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: showForm,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              showForm = false;
                              _domicilioFormKey.currentState.reset();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  showForm
                      ? _form(_domicilioFormKey, scheduler)
                      : Expanded(
                          child: ZMTable(
                            height: 200,
                            model: GruposProducto(),
                            service: GruposProductoService(),
                            listMethodConfiguration: GruposProductoService().buscar(null),
                            paginate: false,
                            fixedActions: [
                              ZMStdButton(
                                color: Colors.green,
                                text: Text(
                                  "Nuevo grupo",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showForm = true;
                                  });
                                },
                              )
                            ],
                            searchArea: Container(
                              child: Card(
                                color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.12),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
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
                                                  hintStyle: TextStyle(
                                                    color: Theme.of(context).canvasColor
                                                  ),
                                                  border: InputBorder.none,
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Theme.of(context).canvasColor  
                                                  ),
                                                  alignLabelWithHint: true,
                                                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0)),
                                              onChanged: (value) {
                                                setState(() {
                                                  searchText = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
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
                                                color: Theme.of(context).canvasColor.withOpacity(0.7),
                                              ),
                                              Container(
                                                width: 250,
                                                child: DropDownMap(
                                                  map: GruposProducto().mapEstados(),
                                                  addAllOption: true,
                                                  addAllText: "Todos",
                                                  addAllValue: "T",
                                                  initialValue: "T",
                                                  textColor: Theme.of(context).canvasColor.withOpacity(0.9),
                                                  dropdownColor: Theme.of(context).primaryColor,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      searchEstado = value;
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
                            cellBuilder: {
                              "GruposProducto": {
                                "Grupo": (value) {
                                  return Text(
                                    value != null ? value.toString() : "-",
                                    textAlign: TextAlign.center,
                                  );
                                },
                                "Descripcion": (value) {
                                  return Text(
                                    value != null ? value.toString() : "-",
                                    textAlign: TextAlign.center,
                                  );
                                }
                              },
                            },
                            tableLabels: {
                              "GruposProducto": {
                                "Descripcion": "Descripción"
                              }
                            },
                            rowActions: (mapModel, index, itemsController) {
                              int idGrupoProducto = 0;
                              String estado;
                              GruposProducto grupoProducto;
                              if (mapModel != null) {
                                if (mapModel["GruposProducto"] != null) {
                                  grupoProducto = GruposProducto().fromMap(mapModel);
                                  idGrupoProducto = grupoProducto.idGrupoProducto;
                                  estado = grupoProducto.estado;
                                }
                              }

                              return <Widget>[
                                IconButtonTableAction(
                                  iconData: (estado == "A"
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward),
                                  color: estado == "A" ? Colors.redAccent : Colors.green,
                                  onPressed: () {
                                    if (idGrupoProducto != 0) {
                                      if (estado == "A") {
                                        GruposProductoService(scheduler: scheduler).baja({
                                          "GruposProducto": {"IdGrupoProducto": idGrupoProducto}
                                        }).then((response) {
                                          if (response.status == RequestStatus.SUCCESS) {
                                            itemsController.add(ItemAction(
                                                event: ItemEvents.Update,
                                                index: index,
                                                updateMethodConfiguration:
                                                    GruposProductoService().dameConfiguration(
                                                        idGrupoProducto)));
                                          }
                                        });
                                      } else {
                                        GruposProductoService().alta({
                                          "GruposProducto": {"IdGrupoProducto": idGrupoProducto}
                                        }).then((response) {
                                          if (response.status == RequestStatus.SUCCESS) {
                                            itemsController.add(ItemAction(
                                                event: ItemEvents.Update,
                                                index: index,
                                                updateMethodConfiguration:
                                                    GruposProductoService().dameConfiguration(
                                                        idGrupoProducto)));
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                                IconButtonTableAction(
                                  iconData: Icons.edit,
                                  onPressed: () {
                                    if (idGrupoProducto != 0) {
                                      
                                    }
                                  },
                                ),
                                IconButtonTableAction(
                                  iconData: Icons.delete_outline,
                                  onPressed: () async {
                                    if (idGrupoProducto != 0) {
                                      await showDialog(
                                        context: context,
                                        barrierColor: Theme.of(context)
                                            .backgroundColor
                                            .withOpacity(0.5),
                                        builder: (BuildContext context) {
                                          return DeleteAlertDialog(
                                            title: "Borrar grupo",
                                            message:
                                                "¿Está seguro que desea eliminar el grupo de productos?",
                                            onAccept: () async {
                                              await GruposProductoService(scheduler: scheduler).borra(
                                                    {
                                                      "GruposProducto": {
                                                        "IdGrupoProducto":
                                                            idGrupoProducto,
                                                      }
                                                    }).then((response) {
                                                if (response.status == RequestStatus.SUCCESS) {
                                                  itemsController.add(ItemAction(
                                                    event: ItemEvents.Hide,
                                                    index: index
                                                  ));
                                                }
                                              });

                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                )
                              ];
                            },
                          ),
                      )
                ],
              )));
    });
  }

  _form(GlobalKey<FormState> key, RequestScheduler scheduler) {
    return Form(
      key: key,
      child: Column(
        children: [
          Container()
        ],
      ),
    );
  }
}
