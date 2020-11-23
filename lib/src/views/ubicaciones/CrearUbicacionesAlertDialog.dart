import 'dart:math';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:zmgestion/src/models/Paises.dart';
import 'package:zmgestion/src/models/Provincias.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/PaisesService.dart';
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
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class CrearUbicacionesAlertDialog extends StatefulWidget {
  final String title;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const CrearUbicacionesAlertDialog(
      {Key key, this.title, this.onSuccess, this.onError})
      : super(key: key);

  @override
  _CrearUbicacionesAlertDialogState createState() =>
      _CrearUbicacionesAlertDialogState();
}

class _CrearUbicacionesAlertDialogState
    extends State<CrearUbicacionesAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _domicilioFisicaFormKey = GlobalKey<FormState>();

  final TextEditingController ubicacionController = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();
  int idTipoDocumento;
  int cantidadHijos = 0;
  String idPais;
  String idPaisDireccion;
  int idProvincia;
  int idCiudad;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idPais = "AR";
    idPaisDireccion = "AR";
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(builder: (scheduler) {
      return AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(0,0,0,0),
          contentPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(0),
          buttonPadding: EdgeInsets.all(0),
          elevation: 1.5,
          scrollable: true,
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: AlertDialogTitle(title: widget.title),
          content: Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Column(
              children: [_form(), _circleIndicator(scheduler)],
            ),
          ));
    });
  }

  _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Ubicación",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline1.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormFieldDialog(
                        controller: ubicacionController,
                        validator: Validator.notEmptyValidator,
                        labelText: "Nombre de la Ubicación",
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextFormFieldDialog(
                        controller: observacionesController,
                        labelText: "Observaciones",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: _domicilioForm(_domicilioFisicaFormKey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _domicilioForm(Key key) {
    return Form(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Domicílio",
                    style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline1.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _addressField(direccionController),
                    SizedBox(
                      width: 12,
                    ),
                    _zipCodeField(codigoPostalController)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _countryField(idPaisDireccion, "Pais"),
                    SizedBox(
                      width: 12,
                    ),
                    _provinciaField(idPais)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ciudadField(idPais, idProvincia),
                    SizedBox(
                      width: 12,
                    ),
                    Container()
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _addressField(TextEditingController controller) {
    return Expanded(
      child: TextFormFieldDialog(
        controller: controller,
        validator: Validator.notEmptyValidator,
        labelText: "Dirección",
      ),
    );
  }

  _zipCodeField(TextEditingController controller) {
    return Expanded(
      child: TextFormFieldDialog(
        controller: controller,
        validator: Validator.notEmptyValidator,
        labelText: "Código Postal",
      ),
    );
  }

  _provinciaField(String _idPais) {
    return Expanded(
      child: DropDownModelView(
        key: Key(idPais),
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

  _countryField(String idPais, String label) {
    return Expanded(
      child: Column(
        key: Key(label),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopLabel(
            labelText: label,
            padding: EdgeInsets.all(0),
          ),
          CountryCodePicker(
            onChanged: print,
            countryFilter: ["AR"],
            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            initialSelection: idPais,
            // optional. Shows only country name and flag
            showCountryOnly: true,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: true,
            // optional. aligns the flag and the Text left
            alignLeft: false,
            hideMainText: false,

            dialogSize: Size(SizeConfig.blockSizeHorizontal * 20,
                SizeConfig.blockSizeVertical * 25),
          ),
        ],
      ),
    );
  }

  _crearUbicacion(RequestScheduler scheduler) {
    Ubicaciones ubicacion = new Ubicaciones(
        ubicacion: ubicacionController.text,
        observaciones: observacionesController.text);
    Domicilios domicilio = Domicilios(
        idPais: idPais,
        domicilio: direccionController.text,
        codigoPostal: codigoPostalController.text,
        idProvincia: idProvincia,
        idCiudad: idCiudad);

    Map<String, dynamic> payload = new Map<String, dynamic>();
    payload.addAll(ubicacion.toMap());
    payload.addAll(domicilio.toMap());
    UbicacionesService(scheduler: scheduler)
        .doMethod(UbicacionesService(scheduler: scheduler)
            .crearUbicacionConfiguration(payload))
        .then((response) {
      if (response.status == RequestStatus.SUCCESS) {
        if (widget.onSuccess != null) {
          widget.onSuccess();
        }
      } else {
        if (widget.onError != null) {
          widget.onError(response.message);
        }
      }
    });
  }

  _circleIndicator(RequestScheduler scheduler) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressButton.icon(
              radius: 7,
              iconedButtons: {
                ButtonState.idle: IconedButton(
                    text: "Crear Ubicación",
                    icon: Icon(Icons.person_add, color: Colors.white),
                    color: Colors.blueAccent),
                ButtonState.loading:
                    IconedButton(text: "Cargando", color: Colors.grey.shade400),
                ButtonState.fail: IconedButton(
                    text: "Error",
                    icon: Icon(Icons.cancel, color: Colors.white),
                    color: Colors.red.shade300),
                ButtonState.success: IconedButton(
                    text: "Éxito",
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    color: Colors.green.shade400)
              },
              padding: EdgeInsets.all(4),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _crearUbicacion(scheduler);
                }
              },
              state: scheduler.isLoading()
                  ? ButtonState.loading
                  : ButtonState.idle,
            ),
          ],
        ),
      ),
    );
  }
}
