import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMUserAction.dart';

class ZMAppBar extends StatelessWidget implements PreferredSizeWidget{

  const ZMAppBar({
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UsuariosProvider _usuariosProvider = Provider.of<UsuariosProvider>(context);
    Usuarios usuario = _usuariosProvider.usuario;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: InkWell(
          onTap: (){
            final NavigationService _navigationService = locator<NavigationService>();
            _navigationService.navigateTo("/inicio");
          },
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
        ZMUserAction(
          usuario: usuario,
        ),
        SizedBox(
          width: 15,
        ),
        ZMTextButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Theme.of(context).primaryColorLight,
          ),
          color: Theme.of(context).primaryColorLight,
          outlineBorder: false,
          text: "Cerrar sesión",
          onPressed: (){
            UsuariosService(context: context).cerrarSesion();
          },
        ),
        SizedBox(
          width: 50,
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => AppBar().preferredSize;
}