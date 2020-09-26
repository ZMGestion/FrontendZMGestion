import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Comprobantes.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';

class CrearComprobanteAlertDialog extends StatefulWidget {
  final String title;

  const CrearComprobanteAlertDialog({Key key, this.title}) : super(key: key);
  @override
  _CrearComprobanteAlertDialogState createState() => _CrearComprobanteAlertDialogState();
}

class _CrearComprobanteAlertDialogState extends State<CrearComprobanteAlertDialog> {

  final _formKey = GlobalKey<FormState>();
  String estado;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                children: [
                  Container(
                    constraints: BoxConstraints(minWidth: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TopLabel(
                          labelText: "Tipo",
                        ),
                        Container(
                          width: 250,
                          child: DropDownMap(
                            map: Comprobantes().mapTipos(),
                            addAllOption: true,
                            initialValue: "R",
                            onChanged: (value) {
                              setState(() {
                                estado = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
        );
      },
    );
  }
}