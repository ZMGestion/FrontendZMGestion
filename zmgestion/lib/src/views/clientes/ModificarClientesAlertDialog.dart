import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/TiposDocumentoService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class ModificarClientesAlertDialog extends StatefulWidget {
  final String title;
  final Clientes cliente;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const ModificarClientesAlertDialog(
      {Key key, this.title, this.onSuccess, this.cliente, this.onError})
      : super(key: key);
  @override
  _ModificarClientesAlertDialogState createState() =>
      _ModificarClientesAlertDialogState();
}

class _ModificarClientesAlertDialogState
    extends State<ModificarClientesAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController razonSocialController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  int idTipoDocumento;
  String idPais;
  String tipo;

  @override
  initState() {
    tipo = widget.cliente.tipo;
    if (tipo == "F") {
      nombresController.text = widget.cliente.nombres;
      apellidosController.text = widget.cliente.apellidos;
    }
    if (tipo == "J") {
      razonSocialController.text = widget.cliente.razonSocial;
    }
    emailController.text = widget.cliente.email;
    idTipoDocumento = widget.cliente.idTipoDocumento;
    documentoController.text = widget.cliente.documento;
    fechaNacimientoController.text =
        DateFormat('dd/MM/yyyy').format(widget.cliente.fechaNacimiento);
    telefonoController.text = widget.cliente.telefono;
    idPais = widget.cliente.idPais;
    super.initState();
  }

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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
      title: AlertDialogTitle(title: widget.title),
      content: Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              tipo == "F" ? _formFisica() : _formJuridica(),
              //Button zone
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ZMStdButton(
                      text: Text(
                        "Aceptar",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Clientes cliente = Clientes(
                            idCliente: widget.cliente.idCliente,
                            idTipoDocumento: idTipoDocumento,
                            documento: documentoController.text,
                            nombres: nombresController.text,
                            apellidos: apellidosController.text,
                            razonSocial: razonSocialController.text,
                            telefono: telefonoController.text,
                            email: emailController.text,
                            tipo: tipo,
                            idPais: idPais,
                            fechaNacimiento:
                                fechaNacimientoController.text != ""
                                    ? DateTime.parse(Jiffy(
                                            fechaNacimientoController.text,
                                            "dd/MM/yyyy")
                                        .format("yyyy-MM-dd"))
                                    : null,
                          );
                          ClientesService()
                              .modifica(cliente.toMap())
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
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _formFisica() {
    return Column(
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
        )
      ],
    );
  }

  _formJuridica() {
    return Column(
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
        )
      ],
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
        initialValue: idTipoDocumento,
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
}
