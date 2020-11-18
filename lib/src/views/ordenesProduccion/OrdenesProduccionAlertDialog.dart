import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionNew.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionVenta.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class OrdenesProduccionAlertDialog extends StatefulWidget{
  final String title;
  final OrdenesProduccion ordenProduccion;

  const OrdenesProduccionAlertDialog({
    Key key,
    this.title = "Orden de producción",
    this.ordenProduccion
  }) : super(key: key);

  @override
  _OrdenesProduccionAlertDialogState createState() => _OrdenesProduccionAlertDialogState();
}

class _OrdenesProduccionAlertDialogState extends State<OrdenesProduccionAlertDialog> {
  bool _desdeCero = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w800,
                        shadows: <Shadow>[
                          Shadow(
                            color: Colors.white.withOpacity(0.3),
                            offset: Offset(1, 1),
                          )
                        ]
                      )
                    ),
                  )
                ],
              ),
            ),
            content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              width: SizeConfig.blockSizeHorizontal * 40,
              constraints: BoxConstraints(
                maxWidth: 600,
                minWidth: 400
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Visibility(
                        visible: _desdeCero,
                        child: OrdenesProduccionNew(
                          title: "Orden de producción",
                          ordenProduccion: widget.ordenProduccion,
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
        );
      }
    );
  }
}