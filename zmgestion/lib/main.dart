import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';

import 'package:zmgestion/src/views/BodyTemplate.dart';
import 'package:zmgestion/src/views/ZMLoader.dart';
import 'package:zmgestion/src/bloc/ThemeBloc.dart';
import 'package:zmgestion/src/bloc/ThemeState.dart';
import 'package:zmgestion/src/router/Router.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/views/login/Login.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';

StreamController<bool> mainLoaderStateController = StreamController<bool>();
RequestScheduler mainRequestScheduler = RequestScheduler(mainLoaderStateController);
BuildContext mainContext;

void main(){
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<UsuariosProvider>(create: (_) => UsuariosProvider()),
      ],
      child: MyApp()
    )
  );
} 

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    mainContext = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState state){
          return Portal(
            child: MaterialApp(
              title: 'Material App',
              theme: state.themeData,
              debugShowCheckedModeBanner: false,
              builder: (context, child) => AppLoader(
                mainRequestScheduler: mainRequestScheduler,
                mainLoaderStreamController: mainLoaderStateController,
                builder: (scheduler){
                  return OKToast(
                    child: ScreenMessage(
                      child: ZMLoader(
                        login: Login(),
                        context: context,
                        child: BodyTemplate(
                          child: child,
                        ),
                      ),
                    ),
                  );
                }
              ),
              navigatorKey: locator<NavigationService>().navigatorKey,
              onGenerateRoute: generateRoute,
              initialRoute: InicioRoute,
            ),
          );
        },
      ),
    );
  }
}