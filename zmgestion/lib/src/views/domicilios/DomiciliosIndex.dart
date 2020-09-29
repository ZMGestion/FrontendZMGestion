import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Comprobantes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/comprobantes/OperacionesComprobanteAlertDialog.dart';
import 'package:zmgestion/src/views/domicilios/CrearDomiciliosAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMBreadCrumb/ZMBreadCrumbItem.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class DomiciliosIndex extends StatefulWidget {
  final Map<String, String> args;

  const DomiciliosIndex({Key key, this.args }) : super(key: key);

  @override
  _DomiciliosIndexState createState() => _DomiciliosIndexState();
}

class _DomiciliosIndexState extends State<DomiciliosIndex> {

  Map<String, String> args = new Map<String, String>();
  Map<String, String> breadcrumb = new Map<String, String>();
  int idCliente = 0;
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
      if (args["IdCliente"] != null){
        idCliente = int.parse(args["IdCliente"]);
        if (idCliente != 0){
          breadcrumb.addAll({
            "Clientes":"/clientes"
          });
        }
      }
    }
    breadcrumb.addAll({
      "Domicilios": null
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
          Flexible(
            fit: FlexFit.tight,
            child: AppLoader(
              builder: (scheduler){
                return ZMTable(
                  model: Domicilios(),
                  height: SizeConfig.blockSizeVertical * 20,
                  service: ClientesService(),
                  listMethodConfiguration: ClientesService().listarDomiciliosConfiguration(idCliente),
                  paginate: false,
                  searchArea: TableTitle(
                    title: "Domicilios",
                  ),
                  fixedActions: [
                    ZMStdButton(
                      color: Colors.green,
                      text: Text(
                        "Agregar domicilio",
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
                        showDialog(
                          context: context,
                          barrierColor: Theme.of(context)
                              .backgroundColor
                              .withOpacity(0.5),
                          builder: (BuildContext context) {
                            return CrearDomiciliosAlertDialog(
                              title: "Agregar domicilio",
                              cliente: Clientes(idCliente: idCliente),
                              onSuccess: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                    )
                  ],
                  rowActions: (mapModel, index, itemsController) {
                    int idDomiclio = 0;
                    Domicilios domicilio;
                    if (mapModel != null) {
                      if (mapModel["Domicilios"] != null) {
                        domicilio = Domicilios().fromMap(mapModel);
                        idDomiclio = domicilio.idDomicilio;
                      }
                    }

                    return <Widget>[
                      IconButtonTableAction(
                        iconData: Icons.delete_outline,
                        onPressed: () async {
                          if (idDomiclio != 0) {
                            await showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return DeleteAlertDialog(
                                  title: "Borrar Domicilio",
                                  message: "¿Está seguro que desea eliminar el domicilio?",
                                  onAccept: () async {
                                    await ClientesService().doMethod(ClientesService(scheduler: scheduler).quitarDomicilioConfiguration({
                                      "Clientes": {
                                        "IdCliente":
                                            idCliente,
                                      },
                                      "Domicilios": {
                                        "IdDomicilio":
                                            domicilio.idDomicilio
                                      }
                                    })).then((response) {
                                      if (response.status == RequestStatus.SUCCESS){
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
                      )
                    ];
                  },
                  cellBuilder: {
                    "Domicilios": {
                      "Domicilio": (value) {
                        return Text(
                          value != null ? value.toString() : "-",
                          textAlign: TextAlign.center,
                        );
                      },
                      "CodigoPostal": (value) {
                        return Text(
                            value != null ? value.toString() : "-",
                            textAlign: TextAlign.center);
                      },
                    },
                    "Ciudades": {
                      "Ciudad": (value) {
                        return Text(
                            value != null ? value.toString() : "-",
                            textAlign: TextAlign.center);
                      }
                    },
                    "Provincias": {
                      "Provincia": (value) {
                        return Text(
                            value != null ? value.toString() : "-",
                            textAlign: TextAlign.center);
                      }
                    },
                    "Paises": {
                      "Pais": (value) {
                        return Text(
                            value != null ? value.toString() : "-",
                            textAlign: TextAlign.center);
                      }
                    },
                  },
                  tableLabels: {
                    "Domicilios": {"CodigoPostal": "Código Postal"}
                  },
                );
              },
            ),
          )
        ],
      ),
      
    );
  }
}