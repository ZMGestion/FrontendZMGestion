import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zmgestion/src/themes/AppTheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmgestion/src/bloc/ThemeBloc.dart';
import 'package:zmgestion/src/bloc/ThemeEvent.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 240),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Bienvenidos a ZMGestion",
                style: GoogleFonts.roboto(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 32
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}