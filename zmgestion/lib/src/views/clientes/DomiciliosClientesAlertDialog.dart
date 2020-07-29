import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/PaisesService.dart';
import 'package:zmgestion/src/services/ProvinciasService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class DomiciliosClientesAlertDialog extends StatefulWidget {
  final String title;
  final Clientes cliente;
  final Function() onSuccess;
  final Function(dynamic) onError;

  DomiciliosClientesAlertDialog(
      {this.title, this.onError, this.onSuccess, this.cliente});

  @override
  _DomiciliosClientesAlertDialogState createState() =>
      _DomiciliosClientesAlertDialogState();
}

class _DomiciliosClientesAlertDialogState
    extends State<DomiciliosClientesAlertDialog> {
  @override
  final _domicilioFormKey = GlobalKey<FormState>();

  bool showForm;
  String idPaisDireccion;
  int idProvincia;
  int idCiudad;

  final TextEditingController direccionController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showForm = false;
    idPaisDireccion = "AR";
  }

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
              height: SizeConfig.blockSizeVertical * 60,
              width: SizeConfig.blockSizeHorizontal * 75,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(24))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: showForm,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              showForm = false;
                              _domicilioFormKey.currentState.reset();
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: !showForm,
                        child: ZMStdButton(
                          color: Colors.green,
                          text: Text(
                            "Nuevo Domicilio",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              showForm = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  showForm
                      ? _form(_domicilioFormKey, scheduler)
                      : ZMTable(
                          model: Domicilios(),
                          height: SizeConfig.blockSizeVertical * 20,
                          service: ClientesService(),
                          listMethodConfiguration: ClientesService()
                              .listarDomiciliosConfiguration(
                                  widget.cliente.idCliente),
                          paginate: false,
                          rowActions: (mapModel, index, itemsController) {
                            int idDomiclio = 0;
                            Domicilios domicilio;
                            if (mapModel != null) {
                              if (mapModel["Domicilios"] != null) {
                                domicilio = Domicilios().fromMap(mapModel);
                                idDomiclio = domicilio.idDomicilio;
                              }
                            }

                            return <Widget>[
                              IconButtonTableAction(
                                iconData: Icons.delete_outline,
                                onPressed: () async {
                                  if (idDomiclio != 0) {
                                    await showDialog(
                                      context: context,
                                      barrierColor: Theme.of(context)
                                          .backgroundColor
                                          .withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return DeleteAlertDialog(
                                          title: "Borrar Domicilio",
                                          message:
                                              "¿Está seguro que desea eliminar el domicilio?",
                                          onAccept: () async {
                                            await ClientesService()
                                                .doMethod(ClientesService(
                                                        scheduler: scheduler)
                                                    .quitarDomicilioConfiguration({
                                              "Clientes": {
                                                "IdCliente":
                                                    widget.cliente.idCliente,
                                              },
                                              "Domicilios": {
                                                "IdDomicilio":
                                                    domicilio.idDomicilio
                                              }
                                            }))
                                                .then((response) {
                                              if (response.status ==
                                                  RequestStatus.SUCCESS) {
                                                itemsController.add(ItemAction(
                                                    event: ItemEvents.Hide,
                                                    index: index));
                                              }
                                            });

                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              )
                            ];
                          },
                          cellBuilder: {
                            "Domicilios": {
                              "Domicilio": (value) {
                                return Text(
                                  value != null ? value.toString() : "-",
                                  textAlign: TextAlign.center,
                                );
                              },
                              "CodigoPostal": (value) {
                                return Text(
                                    value != null ? value.toString() : "-",
                                    textAlign: TextAlign.center);
                              },
                            },
                            "Ciudades": {
                              "Ciudad": (value) {
                                return Text(
                                    value != null ? value.toString() : "-",
                                    textAlign: TextAlign.center);
                              }
                            },
                            "Provincias": {
                              "Provincia": (value) {
                                return Text(
                                    value != null ? value.toString() : "-",
                                    textAlign: TextAlign.center);
                              }
                            },
                            "Paises": {
                              "Pais": (value) {
                                return Text(
                                    value != null ? value.toString() : "-",
                                    textAlign: TextAlign.center);
                              }
                            },
                          },
                          tableLabels: {
                            "Domicilios": {"CodigoPostal": "Código Postal"}
                          },
                        ),
                  // : ModelView(
                  //     isList: true,
                  //     key: Key(showForm.toString()),
                  //     service: ClientesService(scheduler: scheduler),
                  //     listMethodConfiguration:
                  //         ClientesService(scheduler: scheduler)
                  //             .listarDomiciliosConfiguration(
                  //                 widget.cliente.idCliente),
                  //     itemBuilder: (mapModel, index, itemController) {
                  //       Domicilios domicilio =
                  //           Domicilios().fromMap(mapModel);
                  //       return Container(
                  //         color: Colors.red,
                  //         height: 25,
                  //         width: 25,
                  //         child: Text(domicilio.ciudad.ciudad),
                  //       );
                  //     },
                  //     onEmpty: () {
                  //       return Column(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Image.asset(
                  //             "assets/resultEmpty.png",
                  //           ),
                  //           Text(
                  //             "El cliente no tiene domicilios asociados aun",
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 18),
                  //           )
                  //         ],
                  //       );
                  //     },
                  //   ),
                ],
              )));
    });
  }

  _form(GlobalKey<FormState> key, RequestScheduler scheduler) {
    return Form(
      key: key,
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
                _provinciaField(idPaisDireccion)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ciudadField(idPaisDireccion, idProvincia),
                SizedBox(
                  width: 12,
                ),
                Container()
              ],
            ),
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
                        text: "Crear Domicilio",
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
                      ClientesService(scheduler: scheduler)
                          .doMethod(ClientesService(scheduler: scheduler)
                              .agregarDomicilioConfiguration(payload))
                          .then((response) {
                        if (response.status == RequestStatus.SUCCESS) {
                          setState(() {
                            showForm = false;
                          });
                          direccionController.clear();
                          codigoPostalController.clear();
                        } else {}
                      });
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
}
