import 'package:flutter/material.dart';
import 'package:zmgestion/src/themes/AppTheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmgestion/src/bloc/ThemeBloc.dart';
import 'package:zmgestion/src/bloc/ThemeEvent.dart';

class Test extends StatelessWidget {
  const Test({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Testpage")
    );
  }
}