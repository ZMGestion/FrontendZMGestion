import 'package:circular_check_box/circular_check_box.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/PaisesService.dart';
import 'package:zmgestion/src/services/ProvinciasService.dart';
import 'package:zmgestion/src/services/TiposDocumentoService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _domicilioFormKey = GlobalKey<FormState>();
  final _currentPageNotifier = ValueNotifier<int>(0);

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
  bool _personaFisica = true;

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
    idPais = "AR";
    idPaisDireccion = "AR";
    _showAddress = false;
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: AlertDialogTitle(title: widget.title),
          content: Container(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            width: SizeConfig.blockSizeHorizontal * 30,
            constraints: BoxConstraints(
              minWidth: 600,
              maxWidth: 800
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
            ),
            child: Column(
              children: [
                _form(),
                _sendFormButton(scheduler)
              ],
            )
          ));
    });
  }

  _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: _personaFisica ? Theme.of(context).primaryColor : Colors.black.withOpacity(0.05)
                      )
                    )
                  ),
                  child: MaterialButton(
                    onPressed: (){
                      setState(() {
                        _personaFisica = true;
                      });
                    },
                    child: Text(
                      "Persona Física",
                      style: TextStyle(
                        color: _personaFisica ? Theme.of(context).primaryColorLight : null,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: !_personaFisica ? Theme.of(context).primaryColor : Colors.black.withOpacity(0.05)
                      )
                    )
                  ),
                  child: MaterialButton(
                    onPressed: (){
                      setState(() {
                        _personaFisica = false;
                      });
                    },
                    child: Text(
                      "Persona Jurídica",
                      style: TextStyle(
                        color: !_personaFisica ? Theme.of(context).primaryColorLight : null,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Visibility(
                  visible: _personaFisica,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormFieldDialog(
                            controller: nombresController,
                            validator: _personaFisica ? Validator.notEmptyValidator : null,
                            labelText: "Nombres",
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: TextFormFieldDialog(
                            controller: apellidosController,
                            validator: _personaFisica ? Validator.notEmptyValidator : null,
                            labelText: "Apellidos",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !_personaFisica,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormFieldDialog(
                            controller: razonSocialController,
                            validator: !_personaFisica ? Validator.notEmptyValidator : null,
                            labelText: "Razón Social",
                          ),
                        ),
                      ],
                    ),
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
                  child: _domicilioForm(_domicilioFormKey),
                ),
              ],
            ),
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
          Container(
            color: _showAddress ? Colors.black.withOpacity(0.03) : Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: _showAddress ? Theme.of(context).primaryColor : Colors.black.withOpacity(0.05)
                        )
                      )
                    ),
                    child: MaterialButton(
                      onPressed: (){
                        setState(() {
                          _showAddress = !_showAddress;
                        });
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircularCheckBox(
                                  value: _showAddress,
                                  materialTapTargetSize: MaterialTapTargetSize.padded,
                                  onChanged: (value) {
                                    setState(() {
                                      _showAddress = value;
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Domicílio (Opcional)",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                    )
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              _showAddress ? Icons.arrow_drop_up : Icons.arrow_drop_down
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
          Visibility(
            visible: _showAddress,
            child: Padding(
              padding: EdgeInsets.only(top: 12),
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
                        _provinciaField(idPais),
                        SizedBox(
                          width: 12,
                        ),
                        _ciudadField(idPais, idProvincia),
                      ],
                    ),
                  ),
                ],
              ),
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
          Row(
            children: [
              Expanded(
                child: CountryCodePicker(
                  onChanged: print,
                  countryFilter: ["AR"],
                  initialSelection: idPais,
                  showCountryOnly: true,
                  showOnlyCountryWhenClosed: true,
                  alignLeft: false,
                  hideMainText: false,
                  dialogSize: Size(
                    SizeConfig.blockSizeHorizontal * 20,
                    SizeConfig.blockSizeVertical * 25
                  ),
                ),
              ),
            ],
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
    Clientes cliente = Clientes(
      idPais: idPais,
      nombres: _currentPageNotifier.value == 0 ? nombresController.text : null,
      apellidos:
          _currentPageNotifier.value == 0 ? apellidosController.text : null,
      razonSocial:
          _currentPageNotifier.value == 1 ? razonSocialController.text : null,
      idTipoDocumento: idTipoDocumento,
      tipo: !_personaFisica ? "J" : "F",
      documento: documentoController.text,
      telefono: telefonoController.text,
      email: emailController.text,
      fechaNacimiento: fechaNacimientoController.text != ""
          ? DateTime.parse(Jiffy(fechaNacimientoController.text, "dd/MM/yyyy").format("yyyy-MM-dd"))
          : null,
    );
    Map<String, dynamic> payload = new Map<String, dynamic>();
    payload.addAll(cliente.toMap());
    if (_showAddress) {
      if(_domicilioFormKey.currentState.validate()) {
        Domicilios domicilios = Domicilios(
          idPais: idPais,
          domicilio: direccionController.text,
          codigoPostal: codigoPostalController.text,
          idProvincia: idProvincia,
          idCiudad: idCiudad
        );
        payload.addAll(domicilios.toMap());
      }
    }
    ClientesService(scheduler: scheduler).doMethod(
      ClientesService(scheduler: scheduler).crearClienteConfiguration(payload)
    ).then(
      (response) {
        if (response.status == RequestStatus.SUCCESS) {
          if (widget.onSuccess != null) {
            widget.onSuccess();
          }
        } else {
          if (widget.onError != null) {
            widget.onError(response.message);
          }
        }
      }
    );
  }

  _sendFormButton(RequestScheduler scheduler) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZMStdButton(
            color: Theme.of(context).primaryColor,
            text: Text(
              "Crear",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            onPressed: scheduler.isLoading() ? null : () {
              if (_formKey.currentState.validate()) {
                _crearCliente(scheduler);
              }
            }
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
    );
  }
}
