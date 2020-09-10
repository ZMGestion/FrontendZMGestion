import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/PresupuestosService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/views/presupuestos/CrearPresupuestosAlertDialog.dart';
import 'package:zmgestion/src/views/presupuestos/ModificarPresupuestosAlertDialog.dart';
import 'package:zmgestion/src/views/presupuestos/TransformarPresupuestosVentaAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ModelViewDialog.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class PresupuestosIndex extends StatefulWidget {
  @override
  _PresupuestosIndexState createState() => _PresupuestosIndexState();
}

class _PresupuestosIndexState extends State<PresupuestosIndex> {
  Map<int, Presupuestos> presupuestos = {};

  /*ZMTable key*/
  int refreshValue = 0;

  /*Search*/
  String searchText = "";
  String searchIdEstado = "T";
  int searchIdCliente = 0;
  int searchIdUsuario = 0;
  int searchIdUbicacion = 0;
  int searchIdProducto = 0;
  int searchIdTela = 0;
  int searchIdLustre = 0;
  /*Search filters*/
  bool showFilters = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 90,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TopLabel(
                                labelText: "Cliente",
                              ),
                              AutoCompleteField(
                                labelText: "",
                                hintText: "Ingrese un cliente",
                                parentName: "Clientes",
                                keyNameFunc: (mapModel){
                                  String displayedName = "";
                                  if(mapModel["Clientes"]["Nombres"] != null){
                                    displayedName = mapModel["Clientes"]["Nombres"]+" "+mapModel["Clientes"]["Apellidos"];
                                  }else{
                                    displayedName = mapModel["Clientes"]["RazonSocial"];
                                  }
                                  return displayedName;
                                },
                                service: ClientesService(),
                                paginate: true,
                                pageLength: 4,
                                onClear: (){
                                  setState(() {
                                    searchIdCliente = 0;
                                  });
                                },
                                listMethodConfiguration: (searchText){
                                  return ClientesService().buscarClientes({
                                    "Clientes": {
                                      "Nombres": searchText
                                    }
                                  });
                                },
                                onSelect: (mapModel){
                                  if(mapModel != null){
                                    Clientes cliente = Clientes().fromMap(mapModel);
                                    setState(() {
                                      searchIdCliente = cliente.idCliente;
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
                        Expanded(
                          flex: 1,
                          child: Container(
                            constraints: BoxConstraints(minWidth: 200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TopLabel(
                                  labelText: "Ubicación",
                                ),
                                DropDownModelView(
                                  service: UbicacionesService(),
                                  listMethodConfiguration:
                                    UbicacionesService().listar(),
                                  parentName: "Ubicaciones",
                                  labelName: "Seleccione una ubicación",
                                  displayedName: "Ubicacion",
                                  valueName: "IdUbicacion",
                                  allOption: true,
                                  allOptionText: "Todas",
                                  allOptionValue: 0,
                                  initialValue: 0,
                                  errorMessage:
                                    "Debe seleccionar una ubicación",
                                  //initialValue: UsuariosProvider.idUbicacion,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 8)
                                  ),
                                  onChanged: (idSelected) {
                                    setState(() {
                                      searchIdUbicacion = idSelected;
                                    });
                                  },
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
                                labelText: "Producto",
                              ),
                              AutoCompleteField(
                                labelText: "",
                                hintText: "Ingrese un producto",
                                parentName: "Productos",
                                keyName: "Producto",
                                service: ProductosService(),
                                paginate: true,
                                pageLength: 4,
                                onClear: (){
                                  setState(() {
                                    searchIdProducto = 0;
                                  });
                                },
                                listMethodConfiguration: (searchText){
                                  return ProductosService().buscarProductos({
                                    "Productos": {
                                      "Producto": searchText
                                    }
                                  });
                                },
                                onSelect: (mapModel){
                                  if(mapModel != null){
                                    Productos producto = Productos().fromMap(mapModel);
                                    setState(() {
                                      searchIdProducto = producto.idProducto;
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
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TopLabel(
                                labelText: "Tela",
                              ),
                              AutoCompleteField(
                                labelText: "",
                                hintText: "Ingrese una tela",
                                parentName: "Telas",
                                keyName: "Tela",
                                service: TelasService(),
                                paginate: true,
                                pageLength: 4,
                                onClear: (){
                                  setState(() {
                                    searchIdTela = 0;
                                  });
                                },
                                listMethodConfiguration: (searchText){
                                  return TelasService().buscarTelas({
                                    "Telas": {
                                      "Tela": searchText
                                    }
                                  });
                                },
                                onSelect: (mapModel){
                                  if(mapModel != null){
                                    Telas tela = Telas().fromMap(mapModel);
                                    setState(() {
                                      searchIdTela = tela.idTela;
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
                        Expanded(
                          flex: 1,
                          child: Container(
                            constraints: BoxConstraints(minWidth: 200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TopLabel(
                                  labelText: "Lustre",
                                ),
                                DropDownModelView(
                                  service: ProductosFinalesService(),
                                  listMethodConfiguration:
                                    ProductosFinalesService().listarLustres(),
                                  parentName: "Lustres",
                                  labelName: "Seleccione un lustre",
                                  displayedName: "Lustre",
                                  valueName: "IdLustre",
                                  allOption: true,
                                  allOptionText: "Todos",
                                  allOptionValue: 0,
                                  initialValue: 0,
                                  errorMessage:
                                    "Debe seleccionar un lustre",
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 8)
                                  ),
                                  onChanged: (idSelected) {
                                    setState(() {
                                      searchIdLustre = idSelected;
                                    });
                                  },
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
                                    map: Presupuestos().mapEstados(),
                                    addAllOption: true,
                                    addAllText: "Todos",
                                    addAllValue: "T",
                                    initialValue: "T",
                                    onChanged: (value) {
                                      setState(() {
                                        searchIdEstado = value;
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
              AppLoader(builder: (scheduler) {
                return ZMTable(
                  key: Key(searchText + searchIdEstado.toString() + searchIdCliente.toString() + searchIdUsuario.toString() + searchIdUbicacion.toString() + 
                  searchIdProducto.toString() + searchIdTela.toString() + searchIdLustre.toString()),
                  model: Presupuestos(),
                  service: PresupuestosService(),
                  listMethodConfiguration: PresupuestosService().buscarPresupuestos({
                    "Presupuestos": {
                      "Estado": searchIdEstado,
                      "IdCliente": searchIdCliente,
                      "IdUsuario": searchIdUsuario,
                      "IdUbicacion": searchIdUbicacion,
                    },
                    "ProductosFinales": {
                      "IdProducto": searchIdProducto,
                      "IdTela": searchIdTela,
                      "IdLustre": searchIdLustre
                    },
                    "ParametrosBusqueda": {
                      "FechaInicio": "2019-12-12 00:00:00",
                      "FechaFin": "2022-12-12 00:00:00"
                    }
                  }),
                  pageLength: 12,
                  paginate: true,
                  cellBuilder: {
                    "Clientes": {
                      "*": (mapModel){
                        String displayedName = "";
                        if(mapModel["Clientes"]["Nombres"] != null){
                          displayedName = mapModel["Clientes"]["Nombres"]+" "+mapModel["Clientes"]["Apellidos"];
                        }else{
                          displayedName = mapModel["Clientes"]["RazonSocial"];
                        }
                        return Text(
                          displayedName,
                          textAlign: TextAlign.center,
                        );
                      }
                    },
                    "Usuarios": {
                      "*": (mapModel){
                        String displayedName = mapModel["Usuarios"]["Nombres"]+" "+mapModel["Usuarios"]["Apellidos"];
                        return Text(
                          displayedName,
                          textAlign: TextAlign.center,
                        );
                      }
                    },
                    "LineasPresupuesto": {
                      "*": (mapModel){
                        if(mapModel != null){
                          List<Widget> _lineasPresupuesto = List<Widget>();
                          int index = 0;
                          mapModel["LineasPresupuesto"].forEach(
                            (lineaPresupuesto){
                              if(index < 3){
                                LineasProducto _lineaProducto = LineasProducto().fromMap(lineaPresupuesto);
                                _lineasPresupuesto.add(
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "x"+_lineaProducto.cantidad.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7-index*0.15),
                                                  fontSize: 12
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                _lineaProducto.productoFinal.producto.producto + 
                                                " " + (_lineaProducto.productoFinal.tela?.tela??"") +
                                                " " + (_lineaProducto.productoFinal.lustre?.lustre??""),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1-index*0.33)
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                );
                              }
                              index ++;
                            }
                          );
                          return Column(
                            children: _lineasPresupuesto,
                          );
                        }
                        return Container();
                      }
                    },
                    "Presupuestos": {
                      "_PrecioTotal": (value) {
                        return Text(
                          value != null ? "\$"+value.toString() : "-",
                          textAlign: TextAlign.center,
                        );
                      },
                      "Estado": (value) {
                        return Text(
                          Presupuestos().mapEstados()[value.toString()],
                          textAlign: TextAlign.center,
                        );
                      },
                    },
                    "Ubicaciones": {
                      "Ubicacion": (value) {
                        return Text(
                          value.toString(),
                          textAlign: TextAlign.center,
                        );
                      },
                    }
                  },
                  tableLabels: {
                    "Clientes": {
                      "*": "Cliente"
                    },
                    "Usuarios": {
                      "*": "Usuario"
                    },
                    "Presupuestos": {
                      "_PrecioTotal": "Total"
                    },
                    "LineasPresupuesto": {
                      "*": "Detalle"
                    }
                  },
                  defaultWeight: 2,
                  tableWeights: {
                    "Presupuestos": {
                      "Estado": 1,
                      "_PrecioTotal": 1
                    },
                    "LineasPresupuesto": {
                      "*": 5
                    }
                  },
                  fixedActions: [
                    ZMStdButton(
                      color: Colors.green,
                      text: Text(
                        "Nuevo presupuesto",
                        style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold
                        ),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                          builder: (BuildContext context) {
                            return CrearPresupuestosAlertDialog(
                              title: "Crear Presupuestos",
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
                    ),
                    
                  ],
                  onSelectActions: (presupuestos) {
                    bool estadosIguales = true;
                    bool clientesIguales = true;
                    String estado;
                    if (presupuestos.length >= 1) {
                      Map<String, dynamic> anterior;
                      for (Presupuestos presupuesto in presupuestos) {
                        Map<String, dynamic> mapPresupuesto = presupuesto.toMap();
                        if (anterior != null) {
                          if (anterior["Presupuestos"]["Estado"] !=
                            mapPresupuesto["Presupuestos"]["Estado"]) {
                            estadosIguales = false;
                          }
                          if (anterior["Presupuestos"]["IdCliente"] !=
                            mapPresupuesto["Presupuestos"]["IdCliente"]) {
                            clientesIguales = false;
                          }
                        }
                        if (!estadosIguales && !clientesIguales) break;
                        anterior = mapPresupuesto;
                      }
                      if (estadosIguales) {
                        estado = presupuestos[0].toMap()["Presupuestos"]["Estado"];
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
                                    presupuestos.length.toString() +
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
                                      models: presupuestos,
                                      title: (estado == "A"
                                              ? "Dar de baja"
                                              : "Dar de alta") +
                                          " " +
                                          presupuestos.length.toString() +
                                          " presupuestos",
                                      service: PresupuestosService(),
                                      doMethodConfiguration: estado == "E" ? null : null,
                                      payload: (mapModel) {
                                        return {
                                          "Presupuestos": {
                                            "IdPresupuesto": mapModel["Presupuestos"]["IdPresupuesto"]
                                          }
                                        };
                                      },
                                      itemBuilder: (mapModel) {
                                        return Text(mapModel["Presupuestos"]["Presupuesto"]);
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
                      Visibility(
                        visible: clientesIguales && estadosIguales && estado == "C",
                        child: ZMStdButton(
                          color: Colors.blue,
                          text: Text(
                            "Transformar en venta (" + presupuestos.length.toString() + ")",
                            style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold
                            ),
                          ),                        
                          icon: Icon(
                            Icons.compare_arrows,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            if(presupuestos != null){
                              showDialog(
                              context: context,
                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return TransformarPresupuestosVentaAlertDialog(
                                  presupuestos: presupuestos
                                );
                              },
                            );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ZMStdButton(
                        color: Colors.red,
                        text: Text(
                          "Borrar (" + presupuestos.length.toString() + ")",
                          style: TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold
                          ),
                        ),                        
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          if(presupuestos != null){
                            showDialog(
                            context: context,
                            barrierColor: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            builder: (BuildContext context) {
                              return MultipleRequestView(
                                models: presupuestos,
                                title: "Borrar "+presupuestos.length.toString()+" presupuestos",
                                service: PresupuestosService(),
                                doMethodConfiguration: PresupuestosService().borraConfiguration(),
                                payload: (mapModel) {
                                  return {
                                    "Presupuestos": {
                                      "IdPresupuesto": mapModel["Presupuestos"]["IdPresupuesto"]
                                    }
                                  };
                                },
                                itemBuilder: (mapModel) {
                                  return Text(mapModel["Presupuestos"]["Presupuesto"]);
                                },
                                onFinished: () {
                                  setState(() {
                                    refreshValue = Random().nextInt(99999);
                                  });
                                },
                              );
                            },
                          );
                          }
                        },
                      )
                    ];
                  },
                  rowActions: (mapModel, index, itemsController) {
                    Presupuestos presupuesto;
                    String estado = "A";
                    int idPresupuesto = 0;
                    if (mapModel != null) {
                      presupuesto = Presupuestos().fromMap(mapModel);
                      if (mapModel["Presupuestos"] != null) {
                        if (mapModel["Presupuestos"]["Estado"] != null) {
                          estado = mapModel["Presupuestos"]["Estado"];
                        }
                        if (mapModel["Presupuestos"]["IdPresupuesto"] != null) {
                          idPresupuesto = mapModel["Presupuestos"]["IdPresupuesto"];
                        }
                      }
                    }
                    return <Widget>[
                      IconButtonTableAction(
                        iconData: Icons.show_chart,
                        onPressed: () {
                          if (idPresupuesto != 0) {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return ModelViewDialog(
                                  content: ModelView(
                                    service: PresupuestosService(),
                                    getMethodConfiguration: PresupuestosService().dameConfiguration(idPresupuesto),
                                    isList: false,
                                    itemBuilder: (mapModel, index, itemController) {
                                      return Presupuestos().fromMap(mapModel).viewModel(context);
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        }
                      ),
                      IconButtonTableAction(
                        iconData: (estado == "A"
                            ? Icons.arrow_downward
                            : Icons.arrow_upward),
                        color: estado == "A" ? Colors.redAccent : Colors.green,
                        onPressed: () {
                          if (idPresupuesto != 0) {
                            if (estado == "A") {
                              PresupuestosService(scheduler: scheduler).baja({
                                "Presupuestos": {"IdPresupuesto": idPresupuesto}
                              }).then((response) {
                                if (response.status == RequestStatus.SUCCESS) {
                                  itemsController.add(
                                    ItemAction(
                                      event: ItemEvents.Update,
                                      index: index,
                                      updateMethodConfiguration:
                                        PresupuestosService().dameConfiguration(
                                            presupuesto.idPresupuesto
                                        )
                                    )
                                  );
                                }
                              });
                            } else {
                              PresupuestosService().alta({
                                "Presupuestos": {"IdPresupuesto": idPresupuesto}
                              }).then((response) {
                                if (response.status == RequestStatus.SUCCESS) {
                                  itemsController.add(ItemAction(
                                      event: ItemEvents.Update,
                                      index: index,
                                      updateMethodConfiguration:
                                          PresupuestosService().dameConfiguration(
                                              presupuesto.idPresupuesto)));
                                }
                              });
                            }
                          }
                        },
                      ),
                      IconButtonTableAction(
                        iconData: Icons.edit,
                        onPressed: () {
                          if (idPresupuesto != 0) {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return ModelView(
                                  service: PresupuestosService(),
                                  getMethodConfiguration: PresupuestosService().dameConfiguration(idPresupuesto),
                                  isList: false,
                                  itemBuilder: (updatedMapModel, internalIndex, itemController) => ModificarPresupuestosAlertDialog(
                                    title: "Modificar presupuesto",
                                    presupuesto: Presupuestos().fromMap(updatedMapModel),
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                      itemsController.add(ItemAction(
                                          event: ItemEvents.Update,
                                          index: index,
                                          updateMethodConfiguration:
                                              PresupuestosService().dameConfiguration(
                                                  presupuesto.idPresupuesto)));
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      IconButtonTableAction(
                        iconData: Icons.delete_outline,
                        onPressed: () {
                          if (idPresupuesto != 0) {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return DeleteAlertDialog(
                                  title: "Borrar presupuesto",
                                  message:
                                      "¿Está seguro que desea eliminar la presupuesto?",
                                  onAccept: () async {
                                    await PresupuestosService().borra({
                                      "Presupuestos": {"IdPresupuesto": idPresupuesto}
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
                      )
                    ];
                  },
                  searchArea: TableTitle(
                    title: "Presupuestos"
                  )
                );
              }),
            ],
          ),
        ));
  }
}
