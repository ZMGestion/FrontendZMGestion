import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TableTitle extends StatelessWidget {
  final String title;

  const TableTitle({
    Key key, 
    this.title = ""
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                shadows: <Shadow>[
                  Shadow(
                    color: Theme.of(context).primaryColorLight,
                    offset: Offset(1, 1),
                  )
                ]
              )
            ),
          ),
        ],
      )
    );
  }
}