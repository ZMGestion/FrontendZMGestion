import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';

import 'package:zmgestion/src/views/BodyTemplate.dart';
import 'package:zmgestion/src/views/Loader.dart';
import 'package:zmgestion/src/bloc/ThemeBloc.dart';
import 'package:zmgestion/src/bloc/ThemeState.dart';
import 'package:zmgestion/src/router/Router.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';

StreamController<bool> mainLoaderStateController = StreamController<bool>();
RequestScheduler mainRequestScheduler = RequestScheduler(mainLoaderStateController);
void main(){
  setupLocator();
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      title: 'Material App',
      home: Loader(),
      theme: state.themeData,
      builder: (context, child) => BodyTemplate(
        child: child,
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: InicioRoute,
    );
  }
}