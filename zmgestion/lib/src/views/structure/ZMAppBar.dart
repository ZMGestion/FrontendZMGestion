import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';

class ZMAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,

      title: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          child: Text(
              "ZMGestion",
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryTextTheme.headline1.color
              ),
            ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Theme.of(context).primaryColor,
          onPressed: (){
            UsuariosService(context: context).cerrarSesion();
          },
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => AppBar().preferredSize;
}