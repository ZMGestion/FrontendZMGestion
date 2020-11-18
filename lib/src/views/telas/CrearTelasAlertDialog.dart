import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class CrearTelasAlertDialog extends StatefulWidget{
  final String title;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const CrearTelasAlertDialog({
    Key key,
    this.title,
    this.onSuccess,
    this.onError
  }) : super(key: key);

  @override
  _CrearTelasAlertDialogState createState() => _CrearTelasAlertDialogState();
}

class _CrearTelasAlertDialogState extends State<CrearTelasAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController telaController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

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
    Faker faker = new Faker();
    telaController.text = faker.person.lastName();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
      return AppLoader(
        builder: (scheduler){
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(6,6,6,0),
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
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextFormFieldDialog(
                                controller: telaController,
                                validator: Validator.notEmptyValidator,
                                labelText: "Tela",
                              ),
                          ),
                          SizedBox(width: 12,),
                          Expanded(
                              child: TextFormFieldDialog(
                                controller: precioController,
                                validator: Validator.notEmptyValidator,
                                labelText: "Precio",
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Button zone
                    Padding(
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
                            onPressed: scheduler.isLoading() ? null : (){
                              if(_formKey.currentState.validate()){
                                Telas tela = Telas(
                                  tela: telaController.text,
                                  precio: Precios(
                                    precio: double.parse(precioController.text)
                                  ),
                                );
                                TelasService(scheduler: scheduler).crear(tela).then(
                                  (response){
                                    if(response.status == RequestStatus.SUCCESS){
                                      if(widget.onSuccess != null){
                                        widget.onSuccess();
                                      }
                                    }else{
                                      if(widget.onError != null){
                                        widget.onError(response.message);
                                      }
                                    }
                                  }
                                );
                              }
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
                    )
                  ],
                ),
              ),
            ),
        );
      }
    );
  }
}