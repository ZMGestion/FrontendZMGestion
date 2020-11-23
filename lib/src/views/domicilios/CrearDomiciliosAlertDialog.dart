import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:jiffy/jiffy.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/PaisesService.dart';
import 'package:zmgestion/src/services/ProvinciasService.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/services/TiposDocumentoService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class CrearDomiciliosAlertDialog extends StatefulWidget{
  final String title;
  final Clientes cliente;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const CrearDomiciliosAlertDialog({
    Key key,
    this.title,
    this.cliente,
    this.onSuccess,
    this.onError
  }) : super(key: key);

  @override
  _CrearDomiciliosAlertDialogState createState() => _CrearDomiciliosAlertDialogState();
}

class _CrearDomiciliosAlertDialogState extends State<CrearDomiciliosAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _domicilioFormKey = GlobalKey<FormState>();
  
  int idRol;
  int idUbicacion;
  int idTipoDocumento;
  String estadoCivil;
  int cantidadHijos = 0;

  String idPaisDireccion = "AR";
  int idProvincia;
  int idCiudad;
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _provinciaField(String _idPais) {
    return Expanded(
      child: DropDownModelView(
        key: Key(idPaisDireccion),
        service: PaisesService(),
        listMethodConfiguration:
            PaisesService().listarProvinciasConfiguration(_idPais),
        parentName: "Provincias",
        labelName: "Seleccione una provincia",
        displayedName: "Provincia",
        valueName: "IdProvincia",
        errorMessage: "Debe seleccionar una provincia",
        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 8)),
        onChanged: (idSelected) {
          setState(() {
            idProvincia = idSelected;
          });
        },
      ),
    );
  }

  _ciudadField(String _idPais, int _idProvincia) {
    return Expanded(
      child: DropDownModelView(
        key: Key(idProvincia.toString()),
        service: ProvinciasService(),
        listMethodConfiguration: ProvinciasService()
            .listarCiudadesConfiguration(_idPais, _idProvincia),
        parentName: "Ciudades",
        labelName: "Seleccione una ciudad",
        displayedName: "Ciudad",
        valueName: "IdCiudad",
        errorMessage: "Debe seleccionar una ciudad",
        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 8)),
        onChanged: (idSelected) {
          setState(() {
            idCiudad = idSelected;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
      return AppLoader(
        builder: (scheduler){
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0,0,0,0),
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            elevation: 1.5,
            scrollable: true,
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: AlertDialogTitle(
              title: widget.title
            ),
            content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
              ),
              child: Form(
                key: _domicilioFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormFieldDialog(
                              controller: direccionController,
                              validator: Validator.notEmptyValidator,
                              labelText: "Dirección",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormFieldDialog(
                              controller: codigoPostalController,
                              validator: Validator.notEmptyValidator,
                              labelText: "Código postal",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _provinciaField(idPaisDireccion)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ciudadField(idPaisDireccion, idProvincia)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ZMStdButton(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            text: Text(
                              "Agregar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            color: Colors.blue,
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                            disabledColor: Colors.white.withOpacity(0.5),
                            onPressed: () {
                              if (_domicilioFormKey.currentState.validate()) {
                                Domicilios domicilios = Domicilios(
                                    idPais: idPaisDireccion,
                                    domicilio: direccionController.text,
                                    codigoPostal: codigoPostalController.text,
                                    idProvincia: idProvincia,
                                    idCiudad: idCiudad);
                                Map<String, dynamic> payload = new Map<String, dynamic>();
                                payload.addAll(domicilios.toMap());
                                payload.addAll(widget.cliente.toMap());
                                ClientesService(scheduler: scheduler).doMethod(ClientesService(scheduler: scheduler).agregarDomicilioConfiguration(payload)).then((response) {
                                  if (response.status == RequestStatus.SUCCESS) {
                                    direccionController.clear();
                                    codigoPostalController.clear();
                                    if(widget.onSuccess != null){
                                      widget.onSuccess();
                                    }
                                  }
                                });
                              }
                            }
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
        );
      }
    );
  }
}