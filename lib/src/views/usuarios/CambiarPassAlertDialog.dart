import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class CambiarPassAlertDialog extends StatefulWidget {
  final Usuarios usuario;

  const CambiarPassAlertDialog({Key key, this.usuario}) : super(key: key);

  @override
  _CambiarPassAlertDialogState createState() => _CambiarPassAlertDialogState();
}

class _CambiarPassAlertDialogState extends State<CambiarPassAlertDialog> {
  final TextEditingController oldPassController = new TextEditingController();
  final TextEditingController newPassController = new TextEditingController();
  Usuarios usuario;
  bool showOldPass;
  bool showNewPass;

  @override
  void initState() {
    if(widget.usuario != null){
      this.usuario = widget.usuario;
    }
    this.showOldPass = false;
    this.showNewPass = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
        title: "Cambiar contraseña", 
        titleColor: Theme.of(context).primaryColorLight.withOpacity(0.8),
      ),
      content: Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
        width: SizeConfig.blockSizeHorizontal*35,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
        ),
        child: Column(
          children:[
            Row(
              children:[
                Expanded(
                  child: TextFormFieldDialog(
                    controller: oldPassController,
                    labelText: "Contraseña actual",
                    maxLines: 1,
                    obscureText: !showOldPass,
                    suffixIcon: IconButton(
                      icon: Icon(!showOldPass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 15,),
                      onPressed: (){
                        setState(() {
                          showOldPass = !showOldPass;
                        });
                      }
                    ),
                  ),
                ),
              ]
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children:[
                  Expanded(
                    child: TextFormFieldDialog(
                      controller: newPassController,
                      labelText: "Contraseña nueva",
                      obscureText: !showNewPass,
                      maxLines: 1,
                      suffixIcon: IconButton(
                        icon: Icon(!showNewPass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 15,),
                        onPressed: (){
                          setState(() {
                            showNewPass = !showNewPass;
                          });
                        }
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
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
                    onPressed: () async{
                      if(newPassController.text.length > 0 && oldPassController.text.length > 0){
                        await UsuariosService().doMethod(UsuariosService().modificarPassConfiguration({
                          "UsuariosActual":{
                            "Password": oldPassController.text
                          },
                          "UsuariosNuevo":{
                            "Password": newPassController.text
                          },
                        })).then((response){
                          if(response.status == RequestStatus.SUCCESS){
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(
                    width: 15
                  ),
                  ZMTextButton(
                    color: Theme.of(context).primaryColor,
                    text: "Cancelar",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    outlineBorder: false,
                  )
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}