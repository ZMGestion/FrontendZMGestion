import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZMAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu), 
        onPressed: () {
        },
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          child: Text(
              "ZMGestion",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600
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