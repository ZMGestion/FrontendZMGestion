import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/GruposProducto.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/GruposProductoService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/views/productos/ModificarPreciosGrupoProductoAlertDialog.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

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

  final _grupoFormKey = GlobalKey<FormState>();

  bool showForm;
  bool _create = true;

  int idGrupoProducto;
  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController grupoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showForm = false;
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
              width: SizeConfig.blockSizeHorizontal * (showForm ? 45 : 75),
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
                            color: Theme.of(context).canvasColor.withOpacity(0.7),
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              showForm = false;
                              _grupoFormKey.currentState.reset();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  showForm
                      ? _form(_grupoFormKey, context, _create, idGrupoProducto)
                      : Expanded(
                          child: GruposProductoTable(
                            onTapNew: (){
                              setState(() {
                                showForm = true;
                                _create = true;
                              });
                            },
                            onTapUpdate: (mapModel){
                              setState(() {
                                idGrupoProducto = mapModel["Grupos"]["IdGrupoProducto"];
                                showForm = true;
                                _create = false;
                                grupoController.text = mapModel["Grupos"]["Grupo"];
                                descripcionController.text = mapModel["Grupos"]["Descripcion"] != null ? mapModel["Grupos"]["Descripcion"] : "";
                              });
                            },
                          )
                      )
                ],
              )));
    });
  }

  _form(GlobalKey<FormState> formKey,  BuildContext context, bool create, int idGrupoProducto) {
    SizeConfig().init(context);
    return AppLoader(
      builder: (scheduler) => Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              width: SizeConfig.blockSizeHorizontal * 35,
              //color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.15),
              constraints: BoxConstraints(
                minWidth: 450,
                maxWidth: 600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TopLabel(
                                  labelText: "Grupo",
                                  fontSize: 14,
                                  color: Theme.of(context).canvasColor.withOpacity(0.7),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                TextFormField(
                                  controller: grupoController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Nombre del grupo",
                                    fillColor: Theme.of(context).canvasColor
                                  ),
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TopLabel(
                                  labelText: "Descripción",
                                  fontSize: 14,
                                  color: Theme.of(context).canvasColor.withOpacity(0.7),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                TextFormField(
                                  controller: descripcionController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Ingrese una descripción (opcional)",
                                    fillColor: Theme.of(context).canvasColor,
                                  ),
                                  minLines: 4,
                                  maxLines: 6,
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ZMStdButton(
                          text: Text(
                            create ? "Crear" : "Modificar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                          ),
                          color: Colors.green,
                          onPressed: scheduler.isLoading() ? null : (){
                            if(formKey.currentState.validate()){
                              GruposProducto grupoProducto = GruposProducto(
                                idGrupoProducto: idGrupoProducto,
                                grupo: grupoController.text,
                                descripcion: descripcionController.text == "" ? null : descripcionController.text,
                              );
                              if(create){
                                GruposProductoService(scheduler: scheduler).crear(grupoProducto).then(
                                  (response){
                                    if(response.status == RequestStatus.SUCCESS){
                                      setState(() {
                                        showForm = false;
                                      });
                                      grupoController.clear();
                                      descripcionController.clear();
                                    }
                                  }
                                );
                              }else{
                                GruposProductoService(scheduler: scheduler).modifica(grupoProducto.toMap()).then(
                                  (response){
                                    if(response.status == RequestStatus.SUCCESS){
                                      setState(() {
                                        showForm = false;
                                      });
                                      grupoController.clear();
                                      descripcionController.clear();
                                    }
                                  }
                                );
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

class GruposProductoTable extends StatefulWidget {
  final Function onTapNew;
  final Function(Map<String, dynamic>) onTapUpdate;

  const GruposProductoTable({
    Key key, 
    this.onTapNew,
    this.onTapUpdate
  }) : super(key: key);

  @override
  _GruposProductoTableState createState() => _GruposProductoTableState();
}

class _GruposProductoTableState extends State<GruposProductoTable> {
  String searchText = "";
  String searchEstado = "T";

  @override
  Widget build(BuildContext context) {
    return ZMTable(
      modelViewKey: (searchText+searchEstado),
      height: 200,
      model: GruposProducto(),
      service: GruposProductoService(),
      listMethodConfiguration: GruposProductoService().buscar({
        "GruposProducto": {
          "Grupo": searchText,
          "Estado": searchEstado
        }
      }),
      tableBackgroundColor: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.15),
      paginate: true,
      onEmpty: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No hay resultados",
            style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
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
            if(widget.onTapNew != null){
              widget.onTapNew();
            }
          },
        )
      ],
      searchArea: Container(
        child: Card(
          color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.15),
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
                        onChanged: (value){
                          setState(() {
                            searchText = value;
                          });
                        },
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
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0)
                        ),
                        style: TextStyle(
                          color: Theme.of(context).canvasColor
                        ),
                      ),
                    ],
                  ),
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
              style: TextStyle(
                color: Theme.of(context).canvasColor
              ),
            );
          },
          "Descripcion": (value) {
            return Text(
              value != null ? value.toString() : "-",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).canvasColor
              ),
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
        String grupo;
        String descripcion;
        GruposProducto grupoProducto;
        if (mapModel != null) {
          if (mapModel["GruposProducto"] != null) {
            grupoProducto = GruposProducto().fromMap(mapModel);
            idGrupoProducto = grupoProducto.idGrupoProducto;
            estado = grupoProducto.estado;
            grupo = grupoProducto.grupo;
            descripcion = grupoProducto.descripcion;
          }
        }

        return <Widget>[
          ZMTooltip(
            message: "Modificar precios",
            visible: idGrupoProducto != 0,
            child: IconButtonTableAction(
              iconData: Icons.attach_money,
              color: Theme.of(context).canvasColor.withOpacity(0.7),
              onPressed: idGrupoProducto == 0 ? null : () {
                if (idGrupoProducto != 0) {
                  showDialog(
                    context: context,
                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                    builder: (BuildContext context) {
                      return ModificarPreciosGrupoProductoAlertDialog(
                        title: "Modificar precios",
                        grupoProducto: grupoProducto,
                      );
                    },
                  );
                }
              },
            ),
          ),
          ZMTooltip(
            key: Key("EstadoGrupoProducto"+estado.toString()),
            message: estado == "A" ? "Dar de baja" : "Dar de alta",
            theme: estado == "A" ? ZMTooltipTheme.RED : ZMTooltipTheme.GREEN,
            visible: idGrupoProducto != 0,
            child: IconButtonTableAction(
              iconData: (estado == "A" ? Icons.arrow_downward : Icons.arrow_upward),
              color: estado == "A" ? Colors.redAccent : Colors.green,
              onPressed: idGrupoProducto == 0 ? null : () {
                if (idGrupoProducto != 0) {
                  if (estado == "A") {
                    GruposProductoService().baja({
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
          ),
          ZMTooltip(
            message: "Editar",
            visible: idGrupoProducto != 0,
            child: IconButtonTableAction(
              iconData: Icons.edit,
              color: Theme.of(context).canvasColor.withOpacity(0.7),
              onPressed: idGrupoProducto == 0 ? null : () {
                if (idGrupoProducto != 0) {
                  if(widget.onTapUpdate != null){
                    widget.onTapUpdate({
                      "Grupos": {
                        "IdGrupoProducto": idGrupoProducto,
                        "Grupo": grupo,
                        "Descripcion": descripcion
                      }
                    });
                  }
                }
              },
            ),
          ),
          ZMTooltip(
            message: "Borrar",
            theme: ZMTooltipTheme.RED,
            visible: idGrupoProducto != 0,
            child: IconButtonTableAction(
              iconData: Icons.delete_outline,
              color: Theme.of(context).canvasColor.withOpacity(0.7),
              onPressed: idGrupoProducto == 0 ? null : () async {
                if (idGrupoProducto != 0) {
                  await showDialog(
                    context: context,
                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                    builder: (BuildContext context) {
                      return DeleteAlertDialog(
                        title: "Borrar grupo",
                        message: "¿Está seguro que desea eliminar el grupo de productos?",
                        onAccept: () async {
                          await GruposProductoService().borra(
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
            ),
          )
        ];
      },
    );
  }
}
