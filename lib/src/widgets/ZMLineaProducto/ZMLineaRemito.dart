import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Lustres.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/LoadingWidget.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class ZMLineaRemito extends StatefulWidget {
  final int idReferencia;
  final LineasProducto lineaProducto;
  final String tipo;
  final Function(LineasProducto lp) onAccept; 
  final Function() onCancel; 

  const ZMLineaRemito({
    Key key,
    this.idReferencia,
    this.lineaProducto,
    this.onAccept,
    this.onCancel, 
    this.tipo
  }): super(key: key);
  @override
  _ZMLineaRemitoState createState() => _ZMLineaRemitoState();
}

class _ZMLineaRemitoState extends State<ZMLineaRemito> {

  int _cantidad = 0;
  int _idLineaProducto;
  Productos _productoSeleccionado;
  Telas _telaSeleccionada;
  Lustres _lustreSeleccionado;
  int _idLustre;
  bool _loading = true;
  int _idUbicacion;
  String _tipo;
  ProductosFinales _productoFinal;
  int _cantidadDisponible;
  bool _disponible;

  @override
  void initState() {
    if(widget.tipo != null){
      _tipo = widget.tipo;
      if (_tipo == "E" || _tipo == "X"){
        _disponible = true;
      }else{
        _disponible = false;
      }
    }
    if(widget.lineaProducto != null){
      _cantidad = widget.lineaProducto.cantidad;
      if(widget.lineaProducto.idUbicacion != null){
        _idUbicacion = widget.lineaProducto.idUbicacion;
      }
      if(widget.lineaProducto.idLineaProducto != 0){
        _idLineaProducto = widget.lineaProducto.idLineaProducto;
      }
      _lustreSeleccionado = widget.lineaProducto.productoFinal?.lustre;
      _idLustre = widget.lineaProducto.productoFinal?.idLustre??null;
      SchedulerBinding.instance.addPostFrameCallback((_) async{
        Response<Models<dynamic>> responseProducto;
        Response<Models<dynamic>> responseTela;
        if(widget.lineaProducto != null && (_tipo == "S" || _tipo == "Y")){
          await ProductosFinalesService().doMethod(ProductosFinalesService().dameStock({
            "Ubicaciones":{
              "IdUbicacion": _idUbicacion
            },
            "ProductosFinales":{
              "IdProducto": widget.lineaProducto.productoFinal.idProducto,
              "IdLustre": widget.lineaProducto.productoFinal.idLustre,
              "IdTela": widget.lineaProducto.productoFinal.idTela,
            }
          })).then((response){
            if(response.status == RequestStatus.SUCCESS){
              setState(() {
                _productoFinal = ProductosFinales().fromMap(response.message);
                _cantidadDisponible = _productoFinal.cantidad;
              });
            }else{
              setState(() {
                _disponible = false;
              });
            }
          });
        }
        if(widget.lineaProducto.productoFinal.producto?.idProducto != null){
          responseProducto = await ProductosService().damePor(ProductosService().dameConfiguration(widget.lineaProducto.productoFinal.idProducto));
        }
        if(widget.lineaProducto.productoFinal.tela?.idTela != null){
          responseTela = await TelasService().damePor(TelasService().dameConfiguration(widget.lineaProducto.productoFinal.idTela));
        }
        setState(() {
          if(responseProducto?.status == RequestStatus.SUCCESS){
            _productoSeleccionado = Productos().fromMap(responseProducto.message.toMap());
          }
          if(responseTela?.status == RequestStatus.SUCCESS){
            _telaSeleccionada = Telas().fromMap(responseTela.message.toMap());
          }
          _loading = false;
        });
      });
    }else{
      _loading = false;
      _idUbicacion = 0;
    }
    _cantidadDisponible = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Visibility(
            visible: _loading,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 70),
              child: Center(
                child: LoadingWidget()
              ),
            ),
          ),
          Visibility(
            visible: _tipo == "S" || _tipo == "Y",
            child: Card(
              color: Color(0xff042949).withOpacity(0.55),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(minWidth: 200),
                  child: DropDownModelView(
                    service: UbicacionesService(),
                    listMethodConfiguration: UbicacionesService().listar(),
                    parentName: "Ubicaciones",
                    labelName: "Seleccione una ubicación",
                    displayedName: "Ubicacion",
                    valueName: "IdUbicacion",
                    allOption: false,
                    errorMessage: "Debe seleccionar una ubicación",
                    textStyle: TextStyle(
                      color: Color(0xff97D2FF).withOpacity(1),
                    ),
                    iconEnabledColor: Color(0xff97D2FF).withOpacity(1),
                    dropdownColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Color(0xff87C2F5).withOpacity(0.8),  
                      ),
                      hintStyle: TextStyle(
                        color: Color(0xffBADDFB).withOpacity(0.8)
                      ),
                      labelStyle: TextStyle(
                        color: Color(0xffBADDFB).withOpacity(0.8)
                      ),
                    ),
                    onChanged: (idSelected) {
                      setState(() {
                        _idUbicacion = idSelected;
                      });
                    },
                  )
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_loading && ((_tipo == "E" || _tipo == "X") || _idUbicacion != 0),
            child: Card(
              color: Color(0xff042949).withOpacity(0.55),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopLabel(
                            labelText: "Producto",
                            color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.8)
                          ),
                          Container(
                            child: AutoCompleteField(
                              labelText: "",
                              hintText: "Ingrese un producto",
                              parentName: "Productos",
                              keyName: "Producto",
                              service: ProductosService(),
                              paginate: true,
                              pageLength: 4,
                              initialValue: _productoSeleccionado?.producto,
                              invalidTextColor: Color(0xffffaaaa),
                              validTextColor: Color(0xffaaffaa),
                              prefixIcon: Icon(
                                FontAwesomeIcons.boxOpen,
                                size: 17,
                                color: Color(0xff87C2F5).withOpacity(0.8),
                              ),
                              hintStyle: TextStyle(
                                color: Color(0xffBADDFB).withOpacity(0.8)
                              ),
                              onClear: (){
                                setState(() {
                                    _productoSeleccionado = null;
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
                                    _productoSeleccionado = producto;
                                    if(!_productoSeleccionado.esFabricable()){
                                      _telaSeleccionada = null;
                                      _lustreSeleccionado = null;
                                    }else if(_productoSeleccionado.longitudTela <= 0){
                                      _telaSeleccionada = null;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _productoSeleccionado != null ? _productoSeleccionado.esFabricable() : false,
                      child: Expanded(
                        flex: _productoSeleccionado != null ? (_productoSeleccionado.longitudTela > 0 ? 2 : 1) : 1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Visibility(
                              visible: _productoSeleccionado != null ? _productoSeleccionado.longitudTela > 0 : false,
                              child: Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TopLabel(
                                            labelText: "Tela",
                                            color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.8)
                                          ),
                                          AutoCompleteField(
                                            labelText: "",
                                            hintText: "Ingrese una tela",
                                            parentName: "Telas",
                                            keyName: "Tela",
                                            service: TelasService(),
                                            initialValue: _telaSeleccionada?.tela,
                                            paginate: true,
                                            pageLength: 4,
                                            hintStyle: TextStyle(
                                              color: Color(0xffBADDFB).withOpacity(0.8)
                                            ),
                                            prefixIcon: Icon(
                                              FontAwesomeIcons.buffer,
                                              size: 19,
                                              color: Color(0xff87C2F5).withOpacity(0.8),
                                            ),
                                            invalidTextColor: Color(0xffffaaaa),
                                            validTextColor: Color(0xffaaffaa),
                                            onClear: (){
                                              setState(() {
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
                                                  _telaSeleccionada = tela;
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
                            Expanded(
                              flex: 1,
                              child: Container(
                                key: Key(_telaSeleccionada?.tela.toString()),
                                constraints: BoxConstraints(minWidth: 200),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TopLabel(
                                      labelText: "Lustre",
                                      color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.8)
                                    ),
                                    DropDownModelView(
                                      service: ProductosFinalesService(),
                                      listMethodConfiguration: ProductosFinalesService().listarLustres(),
                                      parentName: "Lustres",
                                      labelName: "Seleccione un lustre",
                                      displayedName: "Lustre",
                                      valueName: "IdLustre",
                                      initialValue: _idLustre,
                                      errorMessage:
                                        "Debe seleccionar un lustre",
                                      textStyle: TextStyle(
                                        color: Color(0xff87C2F5).withOpacity(0.8),
                                      ),
                                      modelInfo: (mapModel){
                                        setState(() {
                                          _lustreSeleccionado = Lustres().fromMap(mapModel);
                                        });
                                      },
                                      dropdownColor: Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.brush,
                                          size: 18,
                                          color: Color(0xff87C2F5).withOpacity(0.8),  
                                        ),
                                        hintStyle: TextStyle(
                                          color: Color(0xffBADDFB).withOpacity(0.8)
                                        ),
                                        labelStyle: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                      onChanged: (idSelected) async{
                                        setState(() {
                                          _idLustre = idSelected;
                                        });
                                        if(_tipo == "S" || _tipo == "Y"){
                                          await ProductosFinalesService().doMethod(ProductosFinalesService().dameStock({
                                            "Ubicaciones":{
                                              "IdUbicacion": _idUbicacion
                                            },
                                            "ProductosFinales":{
                                              "IdProducto": _productoSeleccionado.idProducto,
                                              "IdTela": _telaSeleccionada?.idTela,
                                              "IdLustre": _idLustre
                                            }
                                          })).then((response){
                                            if(response.status == RequestStatus.SUCCESS){
                                              setState(() {
                                                _productoFinal = ProductosFinales().fromMap(response.message);
                                                _cantidadDisponible = _productoFinal.cantidad;
                                                _disponible = true;
                                              });
                                            }else{
                                              setState(() {
                                                _disponible = false;
                                                _productoFinal = ProductosFinales();
                                              });
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_loading && _disponible,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: NumberInputWithIncrementDecrement(
                              labelText: "Cantidad",
                              initialValue: _cantidad,
                              textStyle: TextStyle(
                                color: Color(0xffBADDFB)
                              ),
                              hintStyle: TextStyle(
                                color: Color(0xffBADDFB).withOpacity(0.8)
                              ),
                              labelStyle: TextStyle(
                                color: Color(0xffBADDFB).withOpacity(0.8)
                              ),
                              onChanged:  _disponible ? (value){
                                setState(() {
                                  _cantidad = value;
                                });
                              } : null,
                            )
                          ),
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Visibility(
                    visible: _tipo == "S" || _tipo == "Y",
                    child: Expanded(
                      flex: 1,
                        child: Card(
                          color: Color(0xff042949).withOpacity(0.55),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  "Total Disponible",
                                  style: TextStyle(
                                    color: Color(0xffBADDFB).withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        _disponible  ? (_cantidadDisponible - _cantidad).toString() : "-",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600
                                        ),
                                        textAlign: TextAlign.center
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !_loading && !_disponible && _productoFinal != null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Producto no disponible",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
              ],
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZMStdButton(
                color: Theme.of(context).primaryTextTheme.headline6.color,
                icon: Icon(
                  widget.lineaProducto != null ? Icons.edit : Icons.add,
                  color: Theme.of(context).primaryColorLight,
                  size: 16,
                ),
                text: Text(
                  widget.lineaProducto != null ? "Modificar" : "Agregar",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: _loading ? null : (){
                  widget.onAccept(
                    LineasProducto(
                      idLineaProducto: _idLineaProducto,
                      idReferencia: widget.idReferencia,
                      idUbicacion: _idUbicacion,
                      cantidad: _cantidad,
                      productoFinal: ProductosFinales(
                        idLustre: _lustreSeleccionado?.idLustre,
                        idProducto: _productoSeleccionado?.idProducto,
                        idTela: _telaSeleccionada?.idTela,
                        producto: _productoSeleccionado,
                        tela: _telaSeleccionada,
                        lustre: _lustreSeleccionado
                      ),
                    )
                  );
                },
              ),
              SizedBox(
                width: 12,
              ),
              ZMTextButton(
                color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.9),
                text: "Cancelar",
                onPressed: widget.onCancel
              ),
            ],
          )
        ],
      ),
    );
  }
}