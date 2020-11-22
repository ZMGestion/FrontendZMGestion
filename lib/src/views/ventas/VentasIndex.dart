import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
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
import 'package:zmgestion/src/views/ordenesProduccion/GenerarOrdenProduccionVentas.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionAlertDialog.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionVenta.dart';
import 'package:zmgestion/src/views/ventas/GenerarRemitoAlertDialog.dart';
import 'package:zmgestion/src/views/ventas/OperacionesVentaAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ModelViewDialog.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMBreadCrumb/ZMBreadCrumbItem.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class VentasIndex extends StatefulWidget {
  final Map<String, dynamic> args;

  const VentasIndex({Key key, this.args}) : super(key: key);
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
  TextEditingController desdeController = new TextEditingController();
  TextEditingController hastaController = new TextEditingController();
  var dateFormat = DateFormat("yyyy-MM-dd");
  var dateFormatShow = DateFormat("dd/MM/yyyy");
  String fechaInicio = '';
  String fechaHasta = '';
  Timer _debounce;
  RegExp dateRegEx;
  int idVenta;

  Map<String, String> breadcrumb = new Map<String, String>();
  Map<String, dynamic> args = new Map<String, String>();

  @override
  void dispose() {
    desdeController.dispose();
    hastaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    breadcrumb.addAll({
      "Inicio":"/inicio",
      "Ventas": null,
    });
    dateRegEx = RegExp(Utils.regExDate);
    desdeController.addListener(() {
      _debounce = Timer(Duration(milliseconds: 500), (){
        if(dateRegEx.hasMatch(desdeController.text) && fechaInicio != dateFormat.format(DateFormat('dd/MM/yyyy').parse(desdeController.text))){
          setState(() {
            fechaInicio = dateFormat.format(DateFormat('dd/MM/yyyy').parse(desdeController.text));
          });
        }
      });
    });
    hastaController.addListener(() {
      _debounce = Timer(Duration(milliseconds: 500), (){
        if(dateRegEx.hasMatch(hastaController.text) && fechaHasta != dateFormat.format(DateFormat('dd/MM/yyyy').parse(hastaController.text))){
          setState(() {
            fechaHasta = dateFormat.format(DateFormat('dd/MM/yyyy').parse(hastaController.text));
          });
        }
      });
    });
    desdeController.text = dateFormatShow.format(DateTime.now().subtract(Duration(days: 30)));
    hastaController.text = dateFormatShow.format(DateTime.now());
    if (widget.args != null){
      args.addAll(widget.args);
      if (args["IdVenta"] != null){
        idVenta = int.parse(args["IdVenta"]);
        SchedulerBinding.instance.addPostFrameCallback((_) { 
            verVenta(idVenta);
        });
      }
    }
    super.initState();
  }

  void verVenta(int idVenta) async{
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
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                          listMethodConfiguration: UbicacionesService().listar(),
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
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: TextFormFieldDialog(
                                    inputFormatters: [DateTextFormatter()],
                                    controller: desdeController,
                                    labelText: "Desde",
                                    hintText: "dd/mm/yyyy",
                                  ),
                                ),
                                SizedBox(width: 12,),
                                Expanded(
                                  child: TextFormFieldDialog(
                                    inputFormatters: [DateTextFormatter()],
                                    controller: hastaController,
                                    labelText: "Hasta",
                                    hintText: "dd/mm/yyyy",
                                  ),
                                ),
                                
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
                                        : Theme.of(context).iconTheme.color.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: showFilters,
                            child: Row(
                              children: [
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: AppLoader(builder: (scheduler) {
                    return ZMTable(
                      key: Key(searchText + refreshValue.toString() + searchIdEstado.toString() + searchIdCliente.toString() + searchIdUsuario.toString() + searchIdUbicacion.toString() + 
                      searchIdProducto.toString() + searchIdTela.toString() + searchIdLustre.toString() + fechaInicio + fechaHasta),
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
                          "FechaInicio": fechaInicio,
                          "FechaFin": fechaHasta,
                        },
                      }),
                      pageLength: 12,
                      paginate: true,
                      idName: "Cod.",
                      idValue: (mapModel){
                        return mapModel["Ventas"]["IdVenta"].toString();
                      },
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
                              style: TextStyle(
                                  fontWeight: FontWeight.w600
                              ),
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
                                                    _lineaProducto.cantidad.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7-index*0.15),
                                                      fontSize: 13
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
                                                        color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1-index*0.33),
                                                          fontWeight: FontWeight.w600
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
                          "FechaAlta": (value){
                              if(value != null){
                                return Text(
                                  Utils.cuteDateTimeText(DateTime.parse(value)),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600
                                  ),
                                );
                              }else{
                                return Text(
                                  "-",
                                  textAlign: TextAlign.center);
                              }
                            },
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
                        "Ventas": {
                          "_PrecioTotal": "Total",
                          "FechaAlta": "Fecha"
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
                            "Crear venta",
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
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return OperacionesVentasAlertDialog(
                                  title: "Crear venta",
                                  operacion: 'Crear',
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
                        bool todosBorrables = true;
                        bool generableRemito = true;
                        String estado;
                        Ventas venta;
                        if (ventas.length >= 1) {
                          Map<String, dynamic> anterior;
                          for (Ventas ventas in ventas) {
                            Map<String, dynamic> mapVentas = ventas.toMap();
                            if(mapVentas["Ventas"]["Estado"] != 'E'){
                              todosBorrables = false;
                            }
                            if(mapVentas["Ventas"]["Estado"] != 'C'){
                              generableRemito = false;
                            }
                            if (anterior != null) {
                              generableRemito = false;
                              if (anterior["Ventas"]["Estado"] != mapVentas["Ventas"]["Estado"]) {
                                estadosIguales = false;
                              }
                              if (anterior["Ventas"]["IdCliente"] != mapVentas["Ventas"]["IdCliente"]) {
                                clientesIguales = false;
                              }
                            }
                            if (!estadosIguales && !clientesIguales) break;
                            anterior = mapVentas;
                            venta = ventas;
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
                            visible: (!todosBorrables && !generableRemito) && estado != "C",
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
                          SizedBox(
                            width: 6,
                          ),
                          Visibility(
                            visible: estado == "C",
                            child: ZMStdButton(
                              color: Colors.teal,
                              text: Text(
                                "Producir (" + ventas.length.toString() + ")",
                                style: TextStyle(
                                    color: Colors.white, 
                                    fontWeight: FontWeight.bold
                                ),
                              ),           
                              padding: EdgeInsets.only(left: 6),             
                              icon: Icon(
                                FontAwesomeIcons.hammer,
                                color: Colors.white,
                                size: 17,
                              ),
                              onPressed: () {
                                if(ventas != null){
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return GenerarOrdenProduccionVentas(
                                        ventas: ventas,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Visibility(
                            visible: todosBorrables,
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
                          ),
                          Visibility(
                            visible: generableRemito,
                            child: ZMStdButton(
                              color: Colors.blue,
                              text: Text(
                                "Generar Remito",
                                style: TextStyle(
                                    color: Colors.white, 
                                    fontWeight: FontWeight.bold
                                ),
                              ),                        
                              icon: Icon(
                                Icons.local_shipping,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () async{
                                if(ventas != null){
                                  Ventas _venta;
                                  await VentasService(scheduler: scheduler).damePor(VentasService().dameConfiguration(venta.idVenta)).then((response){
                                    if(response.status == RequestStatus.SUCCESS){
                                      setState(() {
                                        _venta = response.message;
                                      });
                                    }
                                  });
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return GenerarRemitoAlertDialog(
                                        venta: _venta,
                                        onSuccess: (){
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
                          ),
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
                          ZMTooltip(
                            message: "Ver venta",
                            visible: idVenta != 0,
                            child: IconButtonTableAction(
                              iconData: Icons.remove_red_eye,
                              onPressed: idVenta == 0 ? null : () async{
                                if (idVenta != 0) {
                                  verVenta(idVenta);
                                }
                              }
                            ),
                          ),
                          ZMTooltip(
                            message: "Modificar",
                            visible: idVenta != 0,
                            child: Opacity(
                              opacity: idVenta == 0 ? 0.2 : (estado  == "E" ? 1 : 0.2),
                              child: IconButtonTableAction(
                                iconData: Icons.edit,
                                onPressed: idVenta == 0 ? null : estado  != "E" ? null : ()async{
                                  Ventas venta;
                                  await VentasService(scheduler: scheduler).damePor(VentasService().dameConfiguration(idVenta)).then((response){
                                    if (response.status == RequestStatus.SUCCESS){
                                      setState(() {
                                        venta = response.message;
                                      });
                                    }
                                  });
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return OperacionesVentasAlertDialog(
                                        title: "Modificar venta",
                                        operacion: 'Modificar',
                                        venta: venta,
                                        onSuccess: () {
                                          Navigator.of(context).pop();
                                          itemsController.add(
                                            ItemAction(
                                              event: ItemEvents.Update,
                                              index: index,
                                              updateMethodConfiguration: VentasService().dameConfiguration(venta.idVenta)
                                            )
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          ZMTooltip(
                            message: "Borrar",
                            theme: ZMTooltipTheme.RED,
                            visible: idVenta != 0,
                            child: IconButtonTableAction(
                              iconData: Icons.delete_outline,
                              onPressed: idVenta == 0 ? null : () {
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
                          ),
                          ZMTooltip(
                            message: "Ver comprobantes",
                            visible: idVenta != 0,
                            child: IconButtonTableAction(
                              iconData: Icons.description,
                              onPressed: idVenta == 0 ? null : () {
                                if (idVenta != 0) {
                                  final NavigationService _navigationService = locator<NavigationService>();
                                  _navigationService.navigateTo("/comprobantes?IdVenta="+idVenta.toString());
                                }
                              }
                            ),
                          ),
                        ];
                      },
                      searchArea: TableTitle(
                        title: "Ventas"
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