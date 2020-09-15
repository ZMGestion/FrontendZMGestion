import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/GruposProducto.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Lustres.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/GruposProductoService.dart';
import 'package:zmgestion/src/services/PresupuestosService.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class CrearPresupuestosAlertDialog extends StatefulWidget{
  final String title;
  final Function() onSuccess;
  final Presupuestos presupuesto;
  final Function(dynamic) onError;

  const CrearPresupuestosAlertDialog({
    Key key,
    this.title,
    this.onSuccess,
    this.presupuesto,
    this.onError
  }) : super(key: key);

  @override
  _CrearPresupuestosAlertDialogState createState() => _CrearPresupuestosAlertDialogState();
}

class _CrearPresupuestosAlertDialogState extends State<CrearPresupuestosAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  
  int _idCliente;
  int _idUbicacion;
  bool ubicacionCargada = false;
  Usuarios usuario;
  Presupuestos presupuesto;
  bool showLineasForm = false;

  int _cantidad = 1;
  double _precioTotal = 0;
  double _precioTotalModificado = 0;
  double _precioUnitario = 0;
  Productos _productoSeleccionado;
  Telas _telaSeleccionada;
  Lustres _lustreSeleccionado;
  int _idLustre = 0;
  bool _priceChanged = false;
  List<Widget> _lineasProducto = [];
  final TextEditingController _precioUnitarioController = TextEditingController();
  final TextEditingController _precioTotalController = TextEditingController();

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
  void initState() {
    presupuesto = widget.presupuesto;
    _precioUnitarioController.addListener(() {
      setState(() {
        _priceChanged = true;
      });
      _setPrecios();
    });
    super.initState();
  }
  
  Widget _lineaProducto(LineasProducto lp){
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "x"+lp.cantidad.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  lp.productoFinal.producto.producto + 
                  (lp.productoFinal.tela != null? " - "+lp.productoFinal.tela.tela : "") +
                  (lp.productoFinal.lustre != null? " - "+lp.productoFinal.lustre.lustre : ""),
                  style: TextStyle(
                  color: Colors.white.withOpacity(1)
                ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$"+lp.precioUnitario.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$"+(lp.precioUnitario * lp.cantidad).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            size: 18,
          ),
          onPressed: (){
            print(lp.precioUnitario);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.cancel_outlined,
            size: 20,
          ),
          onPressed: (){
            showDialog(
              context: context,
              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
              builder: (BuildContext context) {
                return DeleteAlertDialog(
                  title: "Borrar linea de producto",
                  message: "¿Está seguro que desea eliminar la linea?",
                  onAccept: () async {
                    /*await PresupuestosService().borra({
                      "Presupuestos": {"IdPresupuesto": idPresupuesto}
                    }).then((response) {
                      if (response.status == RequestStatus.SUCCESS){
                        itemsController.add(ItemAction(
                            event: ItemEvents.Hide,
                            index: index));
                      }
                    });*/
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if(!ubicacionCargada){
      final UsuariosProvider _usuariosProvider = Provider.of<UsuariosProvider>(context);
      setState(() {
        usuario = _usuariosProvider.usuario;
        ubicacionCargada = true;
        _idUbicacion = usuario.idUbicacion;
      });
    }
      return AppLoader(
        builder: (scheduler){
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            elevation: 1.5,
            scrollable: true,
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: AlertDialogTitle(
              title: widget.title, 
              titleColor: Theme.of(context).primaryColorLight.withOpacity(0.8),
            ),
            content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
              ),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                            color: Theme.of(context).primaryColorLight,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: AutoCompleteField(
                                        prefixIcon: Icon(
                                          Icons.person_outline,
                                          color: Color(0xff87C2F5).withOpacity(0.8),
                                        ),
                                        hintStyle: TextStyle(
                                          color: Color(0xffBADDFB).withOpacity(0.8)
                                        ),
                                        labelStyle: TextStyle(
                                          color: Color(0xffBADDFB).withOpacity(0.8)
                                        ),
                                        labelText: "Cliente",
                                        hintText: "Ingrese un cliente",
                                        invalidTextColor: Color(0xffffaaaa),
                                        validTextColor: Color(0xffaaffaa),
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
                                            _idCliente = 0;
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
                                              _idCliente = cliente.idCliente;
                                            });
                                          }
                                        },
                                      ),
                                  ),
                                  SizedBox(width: 12,),
                                  Expanded(
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
                                        initialValue: usuario.idUbicacion,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                color: Theme.of(context).primaryColorLight,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: !showLineasForm,
                                        child: Column(
                                          children: [
                                            Column(
                                              children: _lineasProducto.length > 0 ? _lineasProducto : [
                                                Visibility(
                                                  visible: _lineasProducto.length <= 0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.info_outline,
                                                          color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.7),
                                                          size: 18,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          "Ingrese al menos una linea",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600,
                                                            color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.8),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ZMTextButton(
                                                  color: Theme.of(context).primaryTextTheme.headline6.color,
                                                  text: "Agregar linea",
                                                  onPressed: (){
                                                    setState(() {
                                                      showLineasForm = true;
                                                    });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: showLineasForm,
                                        child: Column(
                                          children: [
                                            Card(
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
                                            Padding(
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ZMStdButton(
                                                  color: Theme.of(context).primaryTextTheme.headline6.color,
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Theme.of(context).primaryColorLight,
                                                    size: 16,
                                                  ),
                                                  text: Text(
                                                    "Agregar",
                                                    style: TextStyle(
                                                      color: Theme.of(context).primaryColorLight,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  onPressed: () async{
                                                    if(!showLineasForm){
                                                      setState(() {
                                                        showLineasForm = true;
                                                      });
                                                    }else{
                                                      if(_formKey.currentState.validate()){
                                                        bool success = true;
                                                        if(presupuesto == null){
                                                          //Creamos el presupuesto
                                                          Presupuestos _presupuesto = Presupuestos(
                                                            idCliente: _idCliente,
                                                            idUbicacion: _idUbicacion
                                                          );
                                                          await PresupuestosService().crear(_presupuesto).then(
                                                            (response){
                                                              if(response.status == RequestStatus.SUCCESS){
                                                                Presupuestos _presupuestoCreado = Presupuestos().fromMap(response.message);
                                                                setState(() {
                                                                  presupuesto = _presupuestoCreado;
                                                                });
                                                              }else{
                                                                success = false;
                                                                if(widget.onError != null){
                                                                  widget.onError(response.message);
                                                                }
                                                              }
                                                            }
                                                          );
                                                        }
                                                        if(success){
                                                          LineasProducto _lp = LineasProducto(
                                                            idReferencia: presupuesto.idPresupuesto,
                                                            cantidad: _cantidad,
                                                            precioUnitario: _precioUnitario,
                                                            productoFinal: ProductosFinales(
                                                              idProducto: _productoSeleccionado?.idProducto,
                                                              idTela: _telaSeleccionada?.idTela,
                                                              idLustre: _idLustre,
                                                              producto: _productoSeleccionado,
                                                              tela: _telaSeleccionada,
                                                              lustre: _lustreSeleccionado
                                                            ),
                                                          );
                                                          PresupuestosService(scheduler: scheduler).doMethod(PresupuestosService().crearLineaPrespuesto(_lp)).then(
                                                            (response){
                                                              if(response.status == RequestStatus.SUCCESS){
                                                                setState(() {
                                                                  _productoSeleccionado = null;
                                                                  _telaSeleccionada = null;
                                                                  _lustreSeleccionado = null;
                                                                  _idLustre = null;
                                                                  _lineasProducto.add(
                                                                    _lineaProducto(
                                                                      LineasProducto().fromMap(response.message)
                                                                    )
                                                                  );
                                                                  showLineasForm = false;
                                                                });
                                                              }else{
                                                                if(widget.onError != null){
                                                                  widget.onError(response.message);
                                                                }
                                                              }
                                                            }
                                                          );
                                                        }
                                                      }
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                ZMTextButton(
                                                  color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.9),
                                                  text: "Cancelar",
                                                  onPressed: (){
                                                    setState(() {
                                                      showLineasForm = false;
                                                      _productoSeleccionado = null;
                                                      _telaSeleccionada = null;
                                                      _idLustre = 0;
                                                      _cantidad = 0;
                                                      _setPrecios();
                                                    });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Button zone
                        Visibility(
                          visible: !showLineasForm,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ZMStdButton(
                                  color: Theme.of(context).primaryColor,
                                  text: Text(
                                    "Aceptar",
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                  onPressed: scheduler.isLoading() ? null : () async{
                                    
                                  },
                                ),
                                SizedBox(
                                  width: 15
                                ),
                                ZMTextButton(
                                  color: Theme.of(context).primaryColor,
                                  text: "Cancelar",
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  outlineBorder: false,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
        );
      }
    );
  }
}