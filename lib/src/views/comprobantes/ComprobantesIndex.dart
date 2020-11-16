import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Comprobantes.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/comprobantes/OperacionesComprobanteAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMBreadCrumb/ZMBreadCrumbItem.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class ComprobantesIndex extends StatefulWidget {
  final Map<String, String> args;

  const ComprobantesIndex({Key key, this.args }) : super(key: key);

  @override
  _ComprobantesIndexState createState() => _ComprobantesIndexState();
}

class _ComprobantesIndexState extends State<ComprobantesIndex> {

  Map<String, String> args = new Map<String, String>();
  Map<String, String> breadcrumb = new Map<String, String>();
  int idVenta = 0;
  int refreshValue = 0;
  int searchIdUsuario = 0;
  String searchTipo = "T";
  int numeroComprobante = 0;

  @override
  void initState() {
    breadcrumb.addAll({
      "Inicio":"/inicio"
    });
    if (widget.args != null){
      args.addAll(widget.args);
      if (args["IdVenta"] != null){
        idVenta = int.parse(args["IdVenta"]);
        if (idVenta != 0){
          breadcrumb.addAll({
            "Ventas":"/ventas"
          });
        }
      }
      if(args["Crear"] != null){
        if(args["Crear"] == "true"){
          SchedulerBinding.instance.addPostFrameCallback((_) { 
            crearComprobante();
          });
        }
      }
    }
    breadcrumb.addAll({
      "Comprobantes": null
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
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
          Visibility(
            visible: idVenta == 0,
            child: Container(
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
                              inputFormatters: [],
                              decoration: InputDecoration(
                                  hintText: "Número de comprobante",
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.search),
                                  alignLabelWithHint: true,
                                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0)
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null && value != ''){
                                    numeroComprobante = int.parse(value);
                                  }else{
                                    numeroComprobante = 0;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          constraints: BoxConstraints(minWidth: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TopLabel(
                                labelText: "Tipo de comprobante",
                              ),
                              Container(
                                width: 250,
                                child: DropDownMap(
                                  map: Comprobantes().mapTipos(),
                                  addAllOption: true,
                                  addAllText: "Todos",
                                  addAllValue: "T",
                                  initialValue: "T",
                                  onChanged: (value) {
                                    setState(() {
                                      searchTipo = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopLabel(
                              labelText: "Empleado",
                            ),
                            AutoCompleteField(
                              labelText: "",
                              hintText: "Ingrese un empleado",
                              parentName: "Usuarios",
                              keyName: "Usuario",
                              service: UsuariosService(),
                              paginate: true,
                              pageLength: 4,
                              onClear: (){
                                setState(() {
                                  searchIdUsuario = 0;
                                });
                              },
                              listMethodConfiguration: (searchText){
                                return UsuariosService().buscarUsuarios({
                                  "Usuarios": {
                                    "Usuario": searchText
                                  }
                                });
                              },
                              onSelect: (mapModel){
                                if(mapModel != null){
                                  Usuarios usuario = Usuarios().fromMap(mapModel);
                                  setState(() {
                                    searchIdUsuario = usuario.idUsuario;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ),
          Flexible(
            fit: FlexFit.tight,
            child: AppLoader(
              builder: (scheduler){
                return ZMTable(
                  key: Key(refreshValue.toString() + idVenta.toString() + searchTipo + searchIdUsuario.toString() + numeroComprobante.toString()),
                  model: Comprobantes(),
                  service: VentasService(scheduler: scheduler),
                  pageLength: 10,
                  paginate: true,
                  searchArea: TableTitle(
                    title: "Comprobantes"
                  ),
                  listMethodConfiguration: VentasService(scheduler: scheduler).buscarComprobantesConfiguration({
                    "Comprobantes":{
                      "IdVenta": idVenta,
                      "Tipo": searchTipo,
                      "NumeroComprobante": numeroComprobante,
                      "IdUsuario": searchIdUsuario
                    }
                  }),
                  tableLabels: {
                    "Comprobantes": {
                      "NumeroComprobante": "Número comprobante "
                    },
                  },
                  cellBuilder: {
                    "Comprobantes": {
                      "NumeroComprobante": (value) {
                        return Text(
                          value.toString(),
                          textAlign: TextAlign.center,
                        );
                      },
                      "Tipo": (value) {
                        return Text(
                          Comprobantes().mapTipos()[value],
                          textAlign: TextAlign.center,
                        );
                      },
                      "Monto": (value) {
                        return Text(
                          "\$" + value.toString(),
                          textAlign: TextAlign.center,
                        );
                      },
                      "Observaciones": (value) {
                        return Text(
                          value,
                          textAlign: TextAlign.center,
                        );
                      },
                    },
                  },
                  fixedActions: [
                    Visibility(
                      visible: idVenta != 0,
                      child: ZMStdButton(
                        color: Colors.green,
                        text: Text(
                          "Nuevo comprobante",
                          style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: crearComprobante,
                      ),
                    )
                  ],
                  defaultWeight: 2,
                  rowActions: (mapModel, index, itemsController) {
                    Comprobantes comprobante;
                    String estado = "C";
                    int idComprobante = 0;
                    if (mapModel != null) {
                      comprobante = Comprobantes().fromMap(mapModel);
                      if (mapModel["Comprobantes"] != null) {
                        if (mapModel["Comprobantes"]["Estado"] != null) {
                          estado = mapModel["Comprobantes"]["Estado"];
                        }
                        if (mapModel["Comprobantes"]["IdComprobante"] != null) {
                          idComprobante = mapModel["Comprobantes"]["IdComprobante"];
                        }
                      }
                    }
                    return <Widget>[
                      // IconButtonTableAction(
                      //   iconData: Icons.remove_red_eye,
                      //   onPressed: () {
                      //     if (idComprobante != 0) {
                      //       showDialog(
                      //         context: context,
                      //         barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                      //         builder: (BuildContext context) {
                      //           return ModelViewDialog(
                      //             content: ModelView(
                      //               service: UsuariosService(),
                      //               getMethodConfiguration: UsuariosService()
                      //                   .dameConfiguration(idUsuario),
                      //               isList: false,
                      //               itemBuilder: (mapModel, index, itemController) {
                      //                 return Usuarios().fromMap(mapModel).viewModel(context);
                      //               },
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     }
                      //   },
                      // ),
                      ZMTooltip(
                        key: Key("EstadoComprobante"+estado),
                        message: estado == "A" ? "Dar de baja" : "Dar de alta",
                        theme: estado == "A" ? ZMTooltipTheme.RED : ZMTooltipTheme.GREEN,
                        visible: idComprobante != 0,
                        child: IconButtonTableAction(
                          iconData: (estado == "A"
                              ? Icons.arrow_downward
                              : Icons.arrow_upward),
                          color: estado == "A" ? Colors.redAccent : Colors.green,
                          onPressed: idComprobante == 0 ? null : () {
                            if (idComprobante != 0) {
                              if (estado == "A") {
                                VentasService(scheduler: scheduler).doMethod(VentasService().darBajaComprobanteConfiguration({"Comprobantes":{"IdComprobante": idComprobante}})).then((response){
                                  if (response.status == RequestStatus.SUCCESS) {
                                    itemsController.add(
                                      ItemAction(
                                        event: ItemEvents.Update,
                                        index: index,
                                        updateMethodConfiguration: VentasService().dameComprobanteConfiguration(comprobante.idComprobante)
                                      )
                                    );
                                  }
                                });
                              } else {
                                VentasService(scheduler: scheduler).doMethod(VentasService().darAltaComprobanteConfiguration({"Comprobantes":{"IdComprobante": idComprobante}})).then((response){
                                  if (response.status == RequestStatus.SUCCESS) {
                                    itemsController.add(
                                      ItemAction(
                                        event: ItemEvents.Update,
                                        index: index,
                                        updateMethodConfiguration: VentasService().dameComprobanteConfiguration(comprobante.idComprobante)
                                      )
                                    );
                                  }
                                });
                              }
                            }
                          },
                        ),
                      ),
                      ZMTooltip(
                        message: "Editar",
                        visible: idComprobante != 0,
                        child: IconButtonTableAction(
                          iconData: Icons.edit,
                          onPressed: idComprobante == 0 ? null : () async{
                            if (idComprobante != 0) {
                              await showDialog(
                              context: context,
                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return OperacionesComprobanteAlertDialog(
                                  title: "Modificar Comprobante",
                                  comprobante: Comprobantes().fromMap(mapModel),
                                  operacion: "Modificar",
                                );
                              },
                            ).then((value){
                              if(value != null){
                                if(value){
                                  itemsController.add(
                                    ItemAction(
                                      event: ItemEvents.Update,
                                      index: index,
                                      updateMethodConfiguration: VentasService().dameComprobanteConfiguration(comprobante.idComprobante)
                                    )
                                  );
                                }
                              }
                            });
                            }
                          },
                        ),
                      ),
                      ZMTooltip(
                        message: "Borrar",
                        theme: ZMTooltipTheme.RED,
                        visible: idComprobante != 0,
                        child: IconButtonTableAction(
                          iconData: Icons.delete_outline,
                          onPressed: idComprobante == 0 ? null : () {
                            if (idComprobante != 0) {
                              showDialog(
                                context: context,
                                barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                builder: (BuildContext context) {
                                  return DeleteAlertDialog(
                                    title: "Borrar Comprobante",
                                    message:
                                        "¿Está seguro que desea eliminar el comprobante?",
                                    onAccept: () async {
                                      await VentasService(scheduler: scheduler).doMethod(VentasService().borrarComprobanteConfiguration(idComprobante)).then((response) {
                                        if (response.status == RequestStatus.SUCCESS) {
                                          itemsController.add(
                                            ItemAction(
                                              event: ItemEvents.Hide,
                                              index: index
                                            )
                                          );
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
                  // onSelectActions: (comprobantes){
                  //   bool estadosIguales = true;
                  //   String estado;
                  //   if (comprobantes.length >= 1) {
                  //     Map<String, dynamic> anterior;
                  //     for (Comprobantes comprobante in comprobantes) {
                  //       Map<String, dynamic> mapComprobante = comprobante.toMap();
                  //       if (anterior != null) {
                  //         if (anterior["Comprobantes"]["Estado"] != mapComprobante["Comprobantes"]["Estado"]) {
                  //           estadosIguales = false;
                  //         }
                  //       }
                  //       if (!estadosIguales) break;
                  //       anterior = mapComprobante;
                  //     }
                  //     if (estadosIguales) {
                  //       estado = comprobantes[0].toMap()["Comprobantes"]["Estado"];
                  //     }
                  //   }
                  //   return <Widget>[
                  //     Visibility(
                  //       visible: estadosIguales && estado != null,
                  //       child: Row(
                  //         children: [
                  //           ZMStdButton(
                  //             color: Colors.white,
                  //             text: Text(
                  //               (estado == "A"? "Dar de baja": "Dar de alta") +" (" + comprobantes.length.toString() +")",
                  //               style: TextStyle(
                  //                   color: Colors.black87,
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //             icon: Icon(
                  //               estado == "A"? Icons.arrow_downward: Icons.arrow_upward,
                  //               color: estado == "A" ? Colors.red : Colors.green,
                  //               size: 20,
                  //             ),
                  //             onPressed: () {
                  //               showDialog(
                  //                 context: context,
                  //                 barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                  //                 builder: (BuildContext context) {
                  //                   return MultipleRequestView(
                  //                     models: comprobantes,
                  //                     title: (estado == "A"? "Dar de baja": "Dar de alta") +" " + comprobantes.length.toString() +" comprobantes",
                  //                     service: VentasService(),
                  //                     doMethodConfiguration: estado == "A"
                  //                         ? VentasService().darBajaComprobanteConfiguration({"Comprobantes":{"IdComprobante": mapModel["Comprobantes"]["IdComprobante"]}})
                  //                         : VentasService().darAltaComprobanteConfiguration({"Comprobantes":{"IdComprobante": mapModel["Comprobantes"]["IdComprobante"]}}),
                  //                     payload: (mapModel) {
                  //                       return {
                  //                         "Productos": {
                  //                           "IdProducto": mapModel["Productos"]["IdProducto"]
                  //                         }
                  //                       };
                  //                     },
                  //                     itemBuilder: (mapModel) {
                  //                       return Text(mapModel["Productos"]["Producto"]);
                  //                     },
                  //                     onFinished: () {
                  //                       setState(() {
                  //                         refreshValue =
                  //                             Random().nextInt(99999);
                  //                       });
                  //                     },
                  //                   );
                  //                 },
                  //               );
                  //             },
                  //           ),
                  //           SizedBox(
                  //             width: 15,
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ]
                  // },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  crearComprobante() async{
    await showDialog(
      context: context,
      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
      builder: (BuildContext context) {
        return OperacionesComprobanteAlertDialog(
          title: "Crear Comprobante",
          comprobante: Comprobantes(idVenta: idVenta),
          operacion: "Crear",
        );
      },
    ).then((value){
      if(value != null){
        if(value){
          setState(() {
            refreshValue = Random().nextInt(99999);
          });
        }
      }
    });
  }
}