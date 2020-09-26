import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Lustres.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/LoadingWidget.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class ZMLineaProducto extends StatefulWidget {
  final int idReferencia;
  final LineasProducto lineaProducto;
  final Function(LineasProducto lp) onAccept; 
  final Function() onCancel; 

  const ZMLineaProducto({
    Key key,
    this.idReferencia,
    this.lineaProducto,
    this.onAccept,
    this.onCancel
  }): super(key: key);
  @override
  _ZMLineaProductoState createState() => _ZMLineaProductoState();
}

class _ZMLineaProductoState extends State<ZMLineaProducto> {

  final TextEditingController _precioUnitarioController = TextEditingController();
  int _cantidad = 1;
  double _precioTotal = 0;
  double _precioTotalModificado = 0;
  double _precioUnitario = 0;
  Productos _productoSeleccionado;
  Telas _telaSeleccionada;
  Lustres _lustreSeleccionado;
  int _idLustre;
  bool _priceChanged = false;
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    
    if(widget.lineaProducto != null){
      _cantidad = widget.lineaProducto.cantidad;
      
      _lustreSeleccionado = widget.lineaProducto.productoFinal?.lustre;
      _idLustre = widget.lineaProducto.productoFinal?.idLustre??null;
      SchedulerBinding.instance.addPostFrameCallback((_) async{
        Response<Models<dynamic>> responseProducto;
        Response<Models<dynamic>> responseTela;
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
        _setPrecios();
      });
    }else{
      _loading = false;
    }
    super.initState();
  }

  void _setPrecios(){
    double precioOriginal = 0;
    double precioModificado = 0;
    if(_productoSeleccionado != null){
      precioOriginal += _productoSeleccionado.precio.precio;
      if(_telaSeleccionada != null && _productoSeleccionado.longitudTela > 0){
        precioOriginal += _productoSeleccionado.longitudTela * _telaSeleccionada.precio.precio;
      }
    }
    if(!_priceChanged){
      precioModificado = precioOriginal;
    }else{
      if(_precioUnitarioController.text != ""){
        precioModificado = double.parse(_precioUnitarioController.text);
      }
    }
    _precioUnitarioController.text = precioOriginal.toStringAsFixed(2).toString();
    setState(() {
      _precioUnitario = _priceChanged ? precioModificado : precioOriginal;
      _precioTotal = precioOriginal * _cantidad;
      _precioTotalModificado = precioModificado * _cantidad;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          visible: !_loading,
          child: Card(
            key: Key(_productoSeleccionado?.producto??""),
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
                          //constraints: BoxConstraints(maxWidth: _productoSeleccionado == null ? 300 : double.infinity),
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
                                //searchIdProducto = 0;
                                  _productoSeleccionado = null;
                                  _precioUnitarioController.clear();
                                  _setPrecios();
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
                                  _priceChanged = false;
                                  _setPrecios();
                                  //searchIdProducto = producto.idProducto;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    key: Key(_productoSeleccionado?.esFabricable().toString()??"-"),
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
                                              _telaSeleccionada = null;
                                              _setPrecios();
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
                                                _priceChanged = false;
                                                _setPrecios();
                                                //searchIdTela = tela.idTela;
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
                                    onChanged: (idSelected) {
                                      setState(() {
                                        _idLustre = idSelected;
                                      });
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
          visible: !_loading,
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
                            onChanged: (value){
                              setState(() {
                                _cantidad = value;
                              });
                              _setPrecios();
                            },
                          )
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: TextFormFieldDialog(
                              controller: _precioUnitarioController,
                              validator: Validator.notEmptyValidator,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                              labelText: "Precio unitario",
                              textStyle: TextStyle(
                                color: Color(0xffBADDFB)
                              ),
                              hintStyle: TextStyle(
                                color: Color(0xffBADDFB).withOpacity(0.8)
                              ),
                              labelStyle: TextStyle(
                                color: Color(0xffBADDFB).withOpacity(0.8)
                              ),
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
                    child: Card(
                      color: Color(0xff042949).withOpacity(0.55),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                color: Color(0xffBADDFB).withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: _precioTotal != _precioTotalModificado,
                                  child: Row(
                                    children: [
                                      Text.rich(TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "\$"+(_precioTotal.toStringAsFixed(2).toString()),
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.white.withOpacity(0.75),
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "\$"+(_precioTotalModificado.toStringAsFixed(2).toString()),
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
              ],
            ),
          ),
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
                    idReferencia: widget.idReferencia,
                    cantidad: _cantidad,
                    precioUnitario: _precioUnitario,
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
    );
  }
}