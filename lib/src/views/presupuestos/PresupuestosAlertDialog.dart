import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/PresupuestosService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/views/clientes/CrearClientesAlertDialog.dart';
import 'package:zmgestion/src/views/presupuestos/PresupuestoCreadoDialog.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/ConfirmationAlertDialog.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMLineaProducto.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMListLineasProducto.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class PresupuestosAlertDialog extends StatefulWidget{
  final String title;
  final Function() updateAllCallback;
  final Function() updateRowCallback;
  final Presupuestos presupuesto;
  final Function(dynamic) onError;

  const PresupuestosAlertDialog({
    Key key,
    this.title,
    this.updateAllCallback,
    this.updateRowCallback,
    this.presupuesto,
    this.onError
  }) : super(key: key);

  @override
  _PresupuestosAlertDialogState createState() => _PresupuestosAlertDialogState();
}

class _PresupuestosAlertDialogState extends State<PresupuestosAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  
  int _idCliente;
  int _idUbicacion;
  bool ubicacionCargada = false;
  Usuarios usuario;
  Presupuestos presupuesto;
  bool showLineasForm = false;
  LineasProducto _lineaProductoEditando;
  bool _editing = false;
  bool _changed = false;

  List<LineasProducto> _lineasProducto = [];

  @override
  void initState() {
    presupuesto = widget.presupuesto;
    if(presupuesto != null){
      _editing = true;
      _lineasProducto = widget.presupuesto.lineasProducto;
    }
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
        _idUbicacion = presupuesto != null ? presupuesto?.idUbicacion : usuario.idUbicacion;
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: AutoCompleteField(
                                              enabled: presupuesto == null,
                                              actions: [
                                                ZMTooltip(
                                                  message: "Nuevo cliente",
                                                  theme: ZMTooltipTheme.WHITE,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(25),
                                                    onTap: (){
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                                        builder: (BuildContext context) {
                                                          return CrearClientesAlertDialog(
                                                            title: "Nuevo cliente",
                                                            onSuccess: () {
                                                              Navigator.of(context).pop(true);
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(6),
                                                      child: Icon(
                                                        Icons.person_add_sharp,
                                                        size: 20,
                                                        color: Colors.tealAccent.withOpacity(0.8)
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
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
                                              initialValue: Utils.clientName(presupuesto?.cliente),
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12,),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 4),
                                      /*
                                      decoration: BoxDecoration(
                                        color: Color(0x3f000000),
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(10),
                                          right: Radius.circular(10),
                                        )
                                      ),
                                      */
                                      constraints: BoxConstraints(minWidth: 200),
                                      child: DropDownModelView(
                                        service: UbicacionesService(),
                                        listMethodConfiguration: UbicacionesService().listar(),
                                        parentName: "Ubicaciones",
                                        labelName: "Seleccione una ubicación",
                                        displayedName: "Ubicacion",
                                        valueName: "IdUbicacion",
                                        allOption: false,
                                        initialValue: _idUbicacion,
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
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
                                                                _changed = true;
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
                                                ZMStdButton(
                                                  color: Theme.of(context).primaryTextTheme.headline6.color,
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Theme.of(context).primaryColorLight,
                                                    size: 16,
                                                  ),
                                                  text: Text(
                                                    "Agregar linea",
                                                    style: TextStyle(
                                                      color: Theme.of(context).primaryColorLight,
                                                      fontWeight: FontWeight.w600
                                                    )
                                                  ),
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
                                              _lineaProductoEditando = null;
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
                                                if(_lineaProductoEditando != null){
                                                  if(presupuesto != null){
                                                    LineasProducto _lp = LineasProducto(
                                                      idLineaProducto: _lineaProductoEditando.idLineaProducto,
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
                                                    PresupuestosService(scheduler: scheduler).doMethod(PresupuestosService().modificarLineaPresupuesto(_lp)).then(
                                                      (response){
                                                        if(response.status == RequestStatus.SUCCESS){
                                                          setState(() {
                                                            _changed = true;
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
                                                }else{
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
                                                            _changed = true;
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
                                      if(presupuesto.estado == null || presupuesto.estado == "E"){
                                        await PresupuestosService().doMethod(PresupuestosService().pasarACreado(
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
                                              if(_editing){
                                                if(presupuesto.estado == "E"){
                                                  if(widget.updateRowCallback != null){
                                                    widget.updateRowCallback();
                                                  }
                                                }
                                              }else{
                                                if(widget.updateAllCallback != null){
                                                  widget.updateAllCallback();
                                                }
                                              }
                                            }
                                          }
                                        );
                                      }
                                    }
                                    Navigator.of(context).pop();
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
                                      if(presupuesto.estado == null || presupuesto.estado == "E"){
                                        await showDialog(
                                          context: context,
                                          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return ConfirmationAlertDialog(
                                              title: "Presupuesto",
                                              message: "¿Qué desea hacer con el presupuesto?",
                                              acceptText: "Conservar",
                                              cancelText: "Borrar",
                                              acceptColor: Theme.of(context).primaryColorLight,
                                              cancelColor: Colors.red,
                                              acceptIcon: Icon(
                                                Icons.check,
                                                color: Colors.white.withOpacity(0.7),
                                                size: 16,
                                              ),
                                              cancelIcon: Icon(
                                                Icons.delete_outline,
                                                color: Colors.white.withOpacity(0.7),
                                                size: 16,
                                              ),
                                              onAccept: () async {
                                                if(_editing && _changed){
                                                  if(widget.updateRowCallback != null){
                                                    widget.updateRowCallback();
                                                  }
                                                }
                                                if(!_editing){
                                                  widget.updateAllCallback();
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              onCancel: () async {
                                                await PresupuestosService().borra(presupuesto.toMap());
                                                if(widget.updateAllCallback != null){
                                                  widget.updateAllCallback();
                                                }
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        );
                                      }
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