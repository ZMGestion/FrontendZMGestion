import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/views/productos/CrearProductosAlertDialog.dart';
import 'package:zmgestion/src/views/productos/ModificarProductosAlertDialog.dart';
import 'package:zmgestion/src/views/productosFinales/CrearProductosFinalesAlertDialog.dart';
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
import 'package:zmgestion/src/widgets/ZMBreadCrumb/ZMBreadCrumbItem.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class ProductosFinalesIndex extends StatefulWidget {
  @override
  _ProductosIndexState createState() => _ProductosIndexState();
}

class _ProductosIndexState extends State<ProductosFinalesIndex> {
  Map<int, ProductosFinales> productos = {};

  /*ZMTable key*/
  int refreshValue = 0;

  /*Search*/
  int searchIdProducto;
  int searchIdTela;
  int searchIdLustre;
  String searchEstado = "T";
  /*Search filters*/
  bool showFilters = false;
  bool searchByProducto = true;

  ProductosService _productosService = ProductosService();
  ProductosFinalesService _productosFinalesService = ProductosFinalesService();
  Map<String, String> breadcrumb = new Map<String, String>();

  @override
  void initState() {
    breadcrumb.addAll({
      "Inicio":"/inicio",
      "Muebles": null,
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
                                    service: _productosService,
                                    paginate: true,
                                    pageLength: 4,
                                    onClear: (){
                                      setState(() {
                                        searchIdProducto = null;
                                      });
                                    },
                                    listMethodConfiguration: (searchText){
                                      return ProductosService().buscarProductos({
                                        "Productos": {
                                          "Producto": searchText,
                                          "Estado": "A"
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
                                    service: _productosFinalesService,
                                    parentName: "Telas",
                                    keyName: "Tela",
                                    paginate: true,
                                    pageLength: 4,
                                    onClear: (){
                                      setState(() {
                                        searchIdTela = null;
                                      });
                                    },
                                    listMethodConfiguration: (searchText){
                                      return TelasService().buscarTelas({
                                        "Telas": {
                                          "Tela": searchText,
                                          "Estado": "A"
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
                                      listMethodConfiguration: ProductosFinalesService().listarLustres(),
                                      parentName: "Lustres",
                                      labelName: "Seleccione un lustre",
                                      displayedName: "Lustre",
                                      valueName: "IdLustre",
                                      allOption: true,
                                      allOptionText: "Todos",
                                      allOptionValue: 0,
                                      initialValue: 0,
                                      errorMessage: "Debe seleccionar un lustre",
                                      //initialValue: UsuariosProvider.idUbicacion,
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
                                        map: ProductosFinales().mapEstados(),
                                        addAllOption: true,
                                        addAllText: "Todos",
                                        addAllValue: "T",
                                        initialValue: "T",
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
                  Flexible(
                    fit: FlexFit.tight,
                    child: AppLoader(builder: (scheduler) {
                      return ZMTable(
                        key: Key(refreshValue.toString()),
                        modelViewKey: searchIdProducto.toString()+ searchIdLustre.toString() + searchIdTela.toString() + searchEstado.toString(),
                        model: ProductosFinales(),
                        service: ProductosFinalesService(),
                        listMethodConfiguration: ProductosFinalesService().buscarProductos({
                          "ProductosFinales": {
                            "IdProducto": searchIdProducto,
                            "IdTela": searchIdTela,
                            "IdLustre": searchIdLustre,
                            "Estado": searchEstado
                          }
                        }),
                        pageLength: 12,
                        paginate: true,
                        cellBuilder: {
                          "Productos": {
                            "Producto": (value) {
                              return Text(
                                value != null ? value.toString() : "-",
                                textAlign: TextAlign.center,
                              );
                            }
                          },
                          "Telas": {
                            "Tela": (value) {
                              return Text(
                                value != null ? value.toString() : "-",
                                textAlign: TextAlign.center,
                              );
                            }
                          },
                          "Lustres": {
                            "Lustre": (value) {
                              return Text(
                                value != null ? value.toString() : "-",
                                textAlign: TextAlign.center,
                              );
                            }
                          },
                          "ProductosFinales": {
                            "_PrecioTotal": (value) {
                              return Text(
                                value != null ? "\$"+value.toString() : "-",
                                textAlign: TextAlign.center,
                              );
                            },
                          },
                        },
                        tableLabels: {
                          "ProductosFinales": {
                            "_PrecioTotal": "Precio total"
                          }
                        },
                        fixedActions: [
                          ZMStdButton(
                            color: Colors.green,
                            text: Text(
                              "Nuevo mueble",
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
                                  return CrearProductosFinalesAlertDialog(
                                    title: "Crear mueble",
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
                        onSelectActions: (productos) {
                          bool estadosIguales = true;
                          String estado;
                          if (productos.length >= 1) {
                            Map<String, dynamic> anterior;
                            for (ProductosFinales producto in productos) {
                              Map<String, dynamic> mapProducto = producto.toMap();
                              if (anterior != null) {
                                if (anterior["ProductosFinales"]["Estado"] !=
                                    mapProducto["ProductosFinales"]["Estado"]) {
                                  estadosIguales = false;
                                }
                              }
                              if (!estadosIguales) break;
                              anterior = mapProducto;
                            }
                            if (estadosIguales) {
                              estado = productos[0].toMap()["ProductosFinales"]["Estado"];
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
                                          productos.length.toString() +
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
                                            models: productos,
                                            title: (estado == "A"
                                                    ? "Dar de baja"
                                                    : "Dar de alta") +
                                                " " +
                                                productos.length.toString() +
                                                " muebles",
                                            service: ProductosFinalesService(),
                                            doMethodConfiguration: estado == "A"
                                                ? ProductosFinalesService()
                                                    .bajaConfiguration()
                                                : ProductosFinalesService()
                                                    .altaConfiguration(),
                                            payload: (mapModel) {
                                              return {
                                                "ProductosFinales": {
                                                  "IdProductoFinal": mapModel["ProductosFinales"]["IdProductoFinal"]
                                                }
                                              };
                                            },
                                            itemBuilder: (mapModel) {
                                              ProductosFinales productoFinal = ProductosFinales().fromMap(mapModel);

                                              return Text(
                                                productoFinal.producto.producto+" - "+(productoFinal.tela != null ? productoFinal.tela.tela+" - " :"")+productoFinal.lustre?.lustre
                                              );
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
                                "Borrar (" + productos.length.toString() + ")",
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
                                if(productos != null){
                                  showDialog(
                                  context: context,
                                  barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                  builder: (BuildContext context) {
                                    return MultipleRequestView(
                                      models: productos,
                                      title: "Borrar " + productos.length.toString() +" productos",
                                      service: ProductosFinalesService(),
                                      doMethodConfiguration: ProductosFinalesService().borraConfiguration(),
                                      payload: (mapModel) {
                                        return {
                                          "ProductosFinales": {
                                            "IdProductoFinal": mapModel["ProductosFinales"]["IdProductoFinal"]
                                          }
                                        };
                                      },
                                      itemBuilder: (mapModel) {
                                        return Text(
                                          mapModel["Productos"]["Producto"]
                                        );
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
                          String estado = "A";
                          int idProductoFinal = 0;
                          if (mapModel != null) {
                            if (mapModel["ProductosFinales"] != null) {
                              if (mapModel["ProductosFinales"]["Estado"] != null) {
                                estado = mapModel["ProductosFinales"]["Estado"];
                              }
                              if (mapModel["ProductosFinales"]["IdProductoFinal"] != null) {
                                idProductoFinal = mapModel["ProductosFinales"]["IdProductoFinal"];
                              }
                            }
                          }
                          return <Widget>[
                            IconButtonTableAction(
                              iconData: Icons.remove_red_eye,
                              onPressed: () {
                                if (idProductoFinal != 0) {
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return ModelViewDialog(
                                        content: ModelView(
                                          service: ProductosFinalesService(),
                                          getMethodConfiguration: ProductosFinalesService().dameConfiguration(idProductoFinal),
                                          isList: false,
                                          itemBuilder: (mapModel, index, itemController) {
                                            return ProductosFinales().fromMap(mapModel).viewModel(context);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }
                              }
                            ),
                            IconButtonTableAction(
                              iconData: (estado == "A" ? Icons.arrow_downward : Icons.arrow_upward),
                              color: estado == "A" ? Colors.redAccent : Colors.green,
                              onPressed: () {
                                if (idProductoFinal != 0) {
                                  if (estado == "A") {
                                    ProductosFinalesService().baja({
                                      "ProductosFinales": {"IdProductoFinal": idProductoFinal}
                                    }).then((response) {
                                      if (response.status == RequestStatus.SUCCESS) {
                                        itemsController.add(ItemAction(
                                            event: ItemEvents.Update,
                                            index: index,
                                            updateMethodConfiguration: ProductosFinalesService().dameConfiguration(idProductoFinal)));
                                      }
                                    });
                                  } else {
                                    ProductosFinalesService().alta({
                                      "ProductosFinales": {"IdProductoFinal": idProductoFinal}
                                    }).then((response) {
                                      if (response.status == RequestStatus.SUCCESS) {
                                        itemsController.add(ItemAction(
                                            event: ItemEvents.Update,
                                            index: index,
                                            updateMethodConfiguration: ProductosFinalesService().dameConfiguration(idProductoFinal)));
                                      }
                                    });
                                  }
                                }
                              },
                            ),
                            IconButtonTableAction(
                              iconData: Icons.delete_outline,
                              onPressed: () {
                                if (idProductoFinal != 0) {
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context)
                                        .backgroundColor
                                        .withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return DeleteAlertDialog(
                                        title: "Borrar producto",
                                        message:
                                            "¿Está seguro que desea eliminar la producto?",
                                        onAccept: () async {
                                          await ProductosFinalesService().borra({
                                            "ProductosFinales": {"IdProductoFinal": idProductoFinal}
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
                          title: "Muebles"
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
