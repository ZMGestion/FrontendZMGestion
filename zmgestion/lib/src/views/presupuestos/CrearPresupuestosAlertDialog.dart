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
import 'package:zmgestion/src/views/presupuestos/PresupuestoCreadoDialog.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/ConfirmationAlertDialog.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMLineaProducto.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMListLineasProducto.dart';

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
  LineasProducto _lineaProductoEditando;

  List<LineasProducto> _lineasProducto = [];

  final TextEditingController _precioUnitarioController = TextEditingController();
  final TextEditingController _precioTotalController = TextEditingController();

  @override
  void initState() {
    presupuesto = widget.presupuesto;
    super.initState();
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
                                            Visibility(
                                              visible: _lineasProducto.length > 0,
                                              child: ZMListLineasProducto(
                                                key: Key(_lineasProducto.length.toString()),
                                                lineasProducto: _lineasProducto,
                                                onEdit: (LineasProducto lp){
                                                  setState(() {
                                                    _lineaProductoEditando = lp;
                                                    showLineasForm = true;
                                                  });
                                                },
                                                onDelete: (LineasProducto lp){
                                                  showDialog(
                                                    context: context,
                                                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                                    builder: (BuildContext context) {
                                                      return DeleteAlertDialog(
                                                        title: "Borrar linea de producto",
                                                        message: "¿Está seguro que desea eliminar la linea?",
                                                        onAccept: () async {
                                                          PresupuestosService().doMethod(PresupuestosService().borrarLineaPrespuesto({
                                                            "LineasProducto": {"IdLineaProducto": lp.idLineaProducto}
                                                          })).then((response) {
                                                            if (response.status == RequestStatus.SUCCESS){
                                                              setState(() {
                                                                _lineasProducto.remove(lp);
                                                              });
                                                            }
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                      );
                                                    },
                                                  );
                                                }
                                              ),
                                            ),
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
                                        child: ZMLineaProducto(
                                          lineaProducto: _lineaProductoEditando,
                                          onCancel: (){
                                            setState(() {
                                              showLineasForm = false;
                                            });
                                          },
                                          onAccept: (lp) async{
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
                                                    cantidad: lp.cantidad,
                                                    precioUnitario: lp.precioUnitario,
                                                    productoFinal: ProductosFinales(
                                                      idProducto: lp.productoFinal?.idProducto,
                                                      idTela: lp.productoFinal?.idTela,
                                                      idLustre: lp.productoFinal?.idLustre,
                                                      producto: lp.productoFinal?.producto,
                                                      tela: lp.productoFinal?.tela,
                                                      lustre: lp.productoFinal?.lustre
                                                    ),
                                                  );
                                                  PresupuestosService(scheduler: scheduler).doMethod(PresupuestosService().crearLineaPrespuesto(_lp)).then(
                                                    (response){
                                                      if(response.status == RequestStatus.SUCCESS){
                                                        setState(() {
                                                          _lineasProducto.add(
                                                            LineasProducto().fromMap(response.message)
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
                                        )
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
                                    if(presupuesto != null){
                                      PresupuestosService().doMethod(PresupuestosService().pasarACreado(
                                        presupuesto.toMap()
                                      )).then(
                                        (response) async{
                                          if(response.status == RequestStatus.SUCCESS){
                                            await showDialog(
                                              context: context,
                                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return PresupuestoCreadoDialog(
                                                  presupuesto: presupuesto
                                                );
                                              },
                                            );
                                            Navigator.of(context).pop();
                                          }
                                        }
                                      );
                                    }else{
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 15
                                ),
                                ZMTextButton(
                                  color: Theme.of(context).primaryColor,
                                  text: "Cancelar",
                                  onPressed: () async{
                                    if(presupuesto != null){
                                      await showDialog(
                                        context: context,
                                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return ConfirmationAlertDialog(
                                            title: "Presupuesto",
                                            message: "¿Qué desea hacer con los cambios?",
                                            acceptText: "Conservar borrador",
                                            cancelText: "Descartar cambios",
                                            onAccept: () async {
                                              Navigator.of(context).pop();
                                            },
                                            onCancel: () async {
                                              await PresupuestosService().borra(presupuesto.toMap());
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      );
                                    }
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