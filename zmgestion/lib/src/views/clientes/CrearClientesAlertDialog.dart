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

class CrearClientesAlertDialog extends StatefulWidget {
  final String title;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const CrearClientesAlertDialog(
      {Key key, this.title, this.onSuccess, this.onError})
      : super(key: key);

  @override
  _CrearClientesAlertDialogState createState() =>
      _CrearClientesAlertDialogState();
}

class _CrearClientesAlertDialogState extends State<CrearClientesAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _fisicaFormKey = GlobalKey<FormState>();
  final _juridicaFormKey = GlobalKey<FormState>();
  final _domicilioFisicaFormKey = GlobalKey<FormState>();
  final _domicilioJuridicaFormKey = GlobalKey<FormState>();
  PageController _pageController;
  final _currentPageNotifier = ValueNotifier<int>(0);
  int _pageIndex;

  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController razonSocialController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
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
  bool _showAddress;

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
    //Faker faker = new Faker();
    _pageController = new PageController();
    // nombresController.text = faker.person.firstName();
    // apellidosController.text = faker.person.lastName();
    // usuarioController.text = nombresController.text + apellidosController.text;
    // emailController.text = usuarioController.text + "@gmail.com";
    // idRol = 2 + Random().nextInt(1);
    // idUbicacion = 1 + Random().nextInt(2);
    // idTipoDocumento = 1;
    // estadoCivil = "S";
    idPais = "AR";
    idPaisDireccion = "AR";
    _pageIndex = 0;
    _showAddress = false;
    //documentoController.text = (10000000 + Random().nextInt(40000000)).toString();
    // fechaNacimientoController.text = (10 + Random().nextInt(18)).toString() +
    //     "/" +
    //     (10 + Random().nextInt(2)).toString() +
    //     "/" +
    //     (1950 + Random().nextInt(40)).toString();
    // telefonoController.text =
    //     "+54 381 4" + (100000 + Random().nextInt(899999)).toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(builder: (scheduler) {
      return AlertDialog(
          titlePadding: EdgeInsets.all(0),
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
            height: SizeConfig.blockSizeVertical * 90,
            width: SizeConfig.blockSizeHorizontal * 30,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Stack(
              children: [_form(), _circleIndicator(scheduler)],
            ),
          ));
    });
  }

  _form() {
    return PageView(
      controller: _pageController,
      allowImplicitScrolling: true,
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) {
        setState(() {
          _pageIndex = index;
          _currentPageNotifier.value = index;
        });
      },
      children: [_clienteFisicoForm(), _clienteJuridicoForm()],
    );
  }

  _clienteFisicoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _leftArrowButton(_pageIndex),
            Text("Persona Física",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline1.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            _rightArrowButton(_pageIndex),
          ],
        ),
        Form(
          key: _fisicaFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormFieldDialog(
                        controller: nombresController,
                        validator: Validator.notEmptyValidator,
                        labelText: "Nombres",
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextFormFieldDialog(
                        controller: apellidosController,
                        validator: Validator.notEmptyValidator,
                        labelText: "Apellidos",
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
                    _documentTypeField(idTipoDocumento),
                    SizedBox(
                      width: 12,
                    ),
                    _documentField(documentoController),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _phoneField(telefonoController),
                    SizedBox(
                      width: 12,
                    ),
                    _emailField(emailController)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _birthdayField(fechaNacimientoController),
                    SizedBox(
                      width: 12,
                    ),
                    _countryField(idPais, "Nacionalidad")
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

  _clienteJuridicoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _leftArrowButton(_pageIndex),
            Text("Persona Jurídica",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline1.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            _rightArrowButton(_pageIndex)
          ],
        ),
        Form(
          key: _juridicaFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormFieldDialog(
                        controller: razonSocialController,
                        validator: Validator.notEmptyValidator,
                        labelText: "Razón Social",
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
                    _documentTypeField(idTipoDocumento),
                    SizedBox(
                      width: 12,
                    ),
                    _documentField(documentoController),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _phoneField(telefonoController),
                    SizedBox(
                      width: 12,
                    ),
                    _emailField(emailController)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _birthdayField(fechaNacimientoController),
                    SizedBox(
                      width: 12,
                    ),
                    _countryField(idPais, "Nacionalidad")
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: _domicilioForm(_domicilioJuridicaFormKey),
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
              Checkbox(
                  value: _showAddress,
                  onChanged: (value) {
                    setState(() {
                      _showAddress = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Domicílio (Opcional)",
                    style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline1.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ],
          ),
          Visibility(
            visible: _showAddress,
            child: Column(
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
            ),
          )
        ],
      ),
    );
  }

  _emailField(TextEditingController controller) {
    return Expanded(
      child: TextFormFieldDialog(
        controller: controller,
        validator: Validator.emailValidator,
        labelText: "Email",
      ),
    );
  }

  _phoneField(TextEditingController controller) {
    return Expanded(
      child: TextFormFieldDialog(
          controller: controller,
          validator: Validator.notEmptyValidator,
          labelText: "Teléfono"),
    );
  }

  _documentField(TextEditingController controller) {
    return Expanded(
      child: TextFormFieldDialog(
        controller: controller,
        validator: Validator.notEmptyValidator,
        labelText: "Documento",
      ),
    );
  }

  _documentTypeField(int initialValue) {
    return Expanded(
      child: DropDownModelView(
        service: TiposDocumentoService(),
        listMethodConfiguration: TiposDocumentoService().listar(),
        parentName: "TiposDocumento",
        labelName: "Seleccione un tipo de documento",
        displayedName: "TipoDocumento",
        valueName: "IdTipoDocumento",
        initialValue: initialValue,
        errorMessage: "Debe seleccionar un tipo de documento",
        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 8)),
        onChanged: (idSelected) {
          setState(() {
            idTipoDocumento = idSelected;
          });
        },
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

  _birthdayField(TextEditingController controller) {
    return Expanded(
      child: TextFormFieldDialog(
        inputFormatters: [DateTextFormatter()],
        controller: controller,
        labelText: "Fecha nacimiento",
        hintText: "dd/mm/yyyy",
      ),
    );
  }

  _crearCliente(RequestScheduler scheduler) {
    String tipo;
    _currentPageNotifier.value == 0 ? tipo = "F" : tipo = "J";
    Clientes cliente = Clientes(
      idPais: idPais,
      nombres: _currentPageNotifier.value == 0 ? nombresController.text : null,
      apellidos:
          _currentPageNotifier.value == 0 ? apellidosController.text : null,
      razonSocial:
          _currentPageNotifier.value == 1 ? razonSocialController.text : null,
      idTipoDocumento: idTipoDocumento,
      tipo: tipo,
      documento: documentoController.text,
      telefono: telefonoController.text,
      email: emailController.text,
      fechaNacimiento: fechaNacimientoController.text != ""
          ? DateTime.parse(Jiffy(fechaNacimientoController.text, "dd/MM/yyyy")
              .format("yyyy-MM-dd"))
          : null,
    );
    Map<String, dynamic> payload = new Map<String, dynamic>();
    payload.addAll(cliente.toMap());
    if (_showAddress) {
      if ((_pageIndex == 0 &&
              _domicilioFisicaFormKey.currentState.validate()) ||
          (_pageIndex == 1 &&
              _domicilioJuridicaFormKey.currentState.validate())) {
        Domicilios domicilios = Domicilios(
            idPais: idPais,
            domicilio: direccionController.text,
            codigoPostal: codigoPostalController.text,
            idProvincia: idProvincia,
            idCiudad: idCiudad);
        payload.addAll(domicilios.toMap());
      }
    }
    ClientesService(scheduler: scheduler)
        .doMethod(ClientesService(scheduler: scheduler)
            .crearClienteConfiguration(payload))
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

  _rightArrowButton(int index) {
    return IconButton(
        icon: Icon(
          Icons.arrow_right,
          color: index == 0 ? Colors.black87 : Colors.black38,
        ),
        iconSize: 35,
        onPressed: () {
          if (index == 0) {
            setState(() {
              _pageIndex = 1;
            });
            _pageController.jumpToPage(1);
          }
        });
  }

  _leftArrowButton(int index) {
    return IconButton(
        icon: Icon(Icons.arrow_left,
            color: index == 0 ? Colors.black38 : Colors.black),
        iconSize: 35,
        onPressed: () {
          if (index == 1) {
            setState(() {
              _pageIndex = 0;
            });
            _pageController.jumpToPage(0);
          }
        });
  }

  _circleIndicator(RequestScheduler scheduler) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CirclePageIndicator(
                currentPageNotifier: _currentPageNotifier,
                itemCount: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProgressButton.icon(
                      radius: 7,
                      iconedButtons: {
                        ButtonState.idle: IconedButton(
                            text: "Crear Cliente",
                            icon: Icon(Icons.person_add, color: Colors.white),
                            color: Colors.blueAccent),
                        ButtonState.loading: IconedButton(
                            text: "Cargando", color: Colors.grey.shade400),
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
                        if (_fisicaFormKey.currentState.validate() ||
                            _juridicaFormKey.currentState.validate()) {
                          _crearCliente(scheduler);
                        }
                      },
                      state: scheduler.isLoading()
                          ? ButtonState.loading
                          : ButtonState.idle,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
