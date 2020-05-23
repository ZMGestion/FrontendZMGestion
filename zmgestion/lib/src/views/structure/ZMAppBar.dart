import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => AppBar().preferredSize;
}