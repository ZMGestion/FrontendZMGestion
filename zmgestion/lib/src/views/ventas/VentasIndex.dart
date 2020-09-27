import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/ventas/CrearVentaAlertDialog.dart';
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

class VentasIndex extends StatefulWidget {
  @override
  _VentasIndexState createState() => _VentasIndexState();
}

class _VentasIndexState extends State<VentasIndex> {
Map<int, Ventas> ventas = {};

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BreadCrumb(
                      items: <BreadCrumbItem>[
                        BreadCrumbItem(
                          content: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              "Inicio",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor.withOpacity(0.45),
                                fontSize: 15,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                          ),
                          onTap: (){
                            final NavigationService _navigationService = locator<NavigationService>();
                            _navigationService.navigateTo('/inicio');
                          }
                        ),
                        BreadCrumbItem(
                          content: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              "Ventas",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                          ),
                          onTap: null
                        ),
                      ],
                      divider: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                                  map: Ventas().mapEstados(),
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
                key: Key(searchText + refreshValue.toString() + searchIdEstado.toString() + searchIdCliente.toString() + searchIdUsuario.toString() + searchIdUbicacion.toString() + 
                searchIdProducto.toString() + searchIdTela.toString() + searchIdLustre.toString()),
                model: Ventas(),
                service: VentasService(),
                listMethodConfiguration: VentasService().buscarVentas({
                  "Ventas": {
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
                  "LineasVenta": {
                    "*": (mapModel){
                      if(mapModel != null){
                        List<Widget> _lineasVenta = List<Widget>();
                        int index = 0;
                        mapModel["LineasVenta"].forEach(
                          (lineaVenta){
                            if(index < 3){
                              LineasProducto _lineaProducto = LineasProducto().fromMap(lineaVenta);
                              _lineasVenta.add(
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
                                            Flexible(
                                              child: Text(
                                                _lineaProducto.productoFinal.producto.producto + 
                                                " " + (_lineaProducto.productoFinal.tela?.tela??"") +
                                                " " + (_lineaProducto.productoFinal.lustre?.lustre??""),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1-index*0.33)
                                                ),
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
                          children: _lineasVenta,
                        );
                      }
                      return Container();
                    }
                  },
                  "Ventas": {
                    "_PrecioTotal": (value) {
                      return Text(
                        value != null ? "\$"+value.toString() : "-",
                        textAlign: TextAlign.center,
                      );
                    },
                    "Estado": (value) {
                      return Text(
                        Ventas().mapEstados()[value.toString()],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                  "Ventas": {
                    "_PrecioTotal": "Total"
                  },
                  "LineasVenta": {
                    "*": "Detalle"
                  }
                },
                defaultWeight: 2,
                tableWeights: {
                  "Ventas": {
                    "Estado": 2,
                    "_PrecioTotal": 2
                  },
                  "LineasVenta": {
                    "*": 5
                  }
                },
                fixedActions: [
                  ZMStdButton(
                    color: Colors.green,
                    text: Text(
                      "Nueva venta",
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
                          return CrearVentasAlertDialog(
                            title: "Crear Ventas",
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
                onSelectActions: (ventas) {
                  bool estadosIguales = true;
                  bool clientesIguales = true;
                  bool algunVendido = false;
                  String estado;
                  if (ventas.length >= 1) {
                    Map<String, dynamic> anterior;
                    for (Ventas ventas in ventas) {
                      Map<String, dynamic> mapVentas = ventas.toMap();
                      if(mapVentas["Ventas"]["Estado"] == 'V'){
                        algunVendido = true;
                      }
                      if (anterior != null) {
                        if (anterior["Ventas"]["Estado"] != mapVentas["Ventas"]["Estado"]) {
                          estadosIguales = false;
                        }
                        if (anterior["Ventas"]["IdCliente"] != mapVentas["Ventas"]["IdCliente"]) {
                          clientesIguales = false;
                        }
                      }
                      if (!estadosIguales && !clientesIguales) break;
                      anterior = mapVentas;
                    }
                    if (estadosIguales) {
                      estado = ventas[0].toMap()["Ventas"]["Estado"];
                    }
                  }
                  return <Widget>[
                    // Visibility(
                    //   visible: clientesIguales && estadosIguales && estado == "C",
                    //   child: ZMStdButton(
                    //     color: Colors.blue,
                    //     text: Text(
                    //       "Transformar en venta (" + presupuestos.length.toString() + ")",
                    //       style: TextStyle(
                    //           color: Colors.white, 
                    //           fontWeight: FontWeight.bold
                    //       ),
                    //     ),                        
                    //     icon: Icon(
                    //       Icons.compare_arrows,
                    //       color: Colors.white,
                    //       size: 20,
                    //     ),
                    //     onPressed: () {
                    //       if(presupuestos != null){
                    //         showDialog(
                    //         context: context,
                    //         barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                    //         builder: (BuildContext context) {
                    //           return TransformarPresupuestosVentaAlertDialog(
                    //             presupuestos: presupuestos,
                    //             onSuccess: (){
                    //               setState(() {
                    //                 refreshValue =
                    //                     Random().nextInt(99999);
                    //               });
                    //             },
                    //           );
                    //         },
                    //       );
                    //       }
                    //     },
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 15,
                    // ),
                    Visibility(
                      visible: (algunVendido),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Sin acciones",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !algunVendido,
                      child: ZMStdButton(
                        color: Colors.red,
                        text: Text(
                          "Borrar (" + ventas.length.toString() + ")",
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
                          if(ventas != null){
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return MultipleRequestView(
                                  models: ventas,
                                  title: "Borrar "+ventas.length.toString()+" ventas",
                                  service: VentasService(),
                                  doMethodConfiguration: VentasService().borraConfiguration(),
                                  payload: (mapModel) {
                                    return {
                                      "Ventas": {
                                        "IdVenta": mapModel["Ventas"]["IdVenta"]
                                      }
                                    };
                                  },
                                  itemBuilder: (mapModel) {
                                    return Text(mapModel["Ventas"]["IdVenta"].toString());
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
                      ),
                    )
                  ];
                },
                rowActions: (mapModel, index, itemsController) {
                  Ventas venta;
                  String estado = "C";
                  int idVenta = 0;
                  if (mapModel != null) {
                    venta = Ventas().fromMap(mapModel);
                    if (mapModel["Ventas"] != null) {
                      if (mapModel["Ventas"]["Estado"] != null) {
                        estado = mapModel["Ventas"]["Estado"];
                      }
                      if (mapModel["Ventas"]["IdVenta"] != null) {
                        idVenta = mapModel["Ventas"]["IdVenta"];
                      }
                    }
                  }
                  return <Widget>[
                    IconButtonTableAction(
                      iconData: Icons.remove_red_eye,
                      onPressed: () async{
                        if (idVenta != 0) {
                          await showDialog(
                            context: context,
                            barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return ModelViewDialog(
                                title: "Venta",
                                content: ModelView(
                                  service: VentasService(),
                                  getMethodConfiguration: VentasService().dameConfiguration(idVenta),
                                  isList: false,
                                  itemBuilder: (mapModel, index, itemController) {
                                    return Ventas().fromMap(mapModel).viewModel(context);
                                  },
                                ),
                              );
                            },
                          ).then((value){
                            if(value != null){
                              if (value){
                                setState(() {
                                  refreshValue = Random().nextInt(99999);
                                });
                              }
                            }   
                          });
                        }
                      }
                    ),
                    IconButtonTableAction(
                      iconData: Icons.edit,
                      onPressed: () {
                        if (idVenta != 0) {
                          showDialog(
                            context: context,
                            barrierColor: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            builder: (BuildContext context) {
                              return ModelView(
                                service: VentasService(),
                                getMethodConfiguration: VentasService().dameConfiguration(idVenta),
                                isList: false,
                                itemBuilder: (updatedMapModel, internalIndex, itemController) {
                                  return Container();
                                  // return ModificarPresupuestosAlertDialog(
                                  //   title: "Modificar presupuesto",
                                  //   presupuesto: Presupuestos().fromMap(updatedMapModel),
                                  //   onSuccess: () {
                                  //     Navigator.of(context).pop();
                                  //     itemsController.add(ItemAction(
                                  //         event: ItemEvents.Update,
                                  //         index: index,
                                  //         updateMethodConfiguration: VentasService().dameConfiguration(venta.idVenta)));
                                  //   },
                                  // );
                                } ,
                              );
                            },
                          );
                        }
                      },
                    ),
                    IconButtonTableAction(
                      iconData: Icons.delete_outline,
                      onPressed: () {
                        if (idVenta != 0) {
                          showDialog(
                            context: context,
                            barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return DeleteAlertDialog(
                                title: "Borrar venta",
                                message: "¿Está seguro que desea eliminar la venta?",
                                onAccept: () async {
                                  await VentasService().borra({
                                    "Ventas": {"IdVenta": idVenta}
                                  }).then((response) {
                                    if (response.status == RequestStatus.SUCCESS) {
                                      itemsController.add(
                                        ItemAction(
                                          event: ItemEvents.Hide,
                                          index: index)
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
                    IconButtonTableAction(
                        iconData: Icons.description,
                        onPressed: () {
                          if (idVenta != 0) {
                            final NavigationService _navigationService = locator<NavigationService>();
                            _navigationService.navigateTo("/comprobantes?IdVenta="+idVenta.toString());
                          }
                        }
                    ),
                  ];
                },
                searchArea: TableTitle(
                  title: "Ventas"
                )
              );
            }),
          ],
        ),
      ));
  }



}