import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';

class AppLoader extends StatefulWidget{

  final Widget Function(RequestScheduler scheduler) builder;
  final RequestScheduler mainRequestScheduler;
  final StreamController<bool> mainLoaderStreamController;
  final bool showLoading;

  const AppLoader({
    this.builder,
    this.mainRequestScheduler,
    this.mainLoaderStreamController,
    this.showLoading = false
  });

  @override
  _AppLoaderState createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {

  RequestScheduler requestScheduler;
  StreamController<bool> loaderStreamController;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    loaderStreamController.close();
    //requestScheduler.close();
    requestScheduler.requests.forEach((request) async{
      if(request.requestConfiguration.alertOnExit != null && request.status == RequestStatus.PENDING) {
        print("UNA REQUEST PRETENDIA ALERTAR AQUI ANTES DE SALIR");
      }
    });
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    if(widget.mainLoaderStreamController != null){
      loaderStreamController = widget.mainLoaderStreamController;
    }else{
      loaderStreamController = StreamController<bool>();
    }

    if(widget.mainRequestScheduler != null){
      requestScheduler = widget.mainRequestScheduler;
    }else{
      requestScheduler = RequestScheduler(loaderStreamController);
    }

    loaderStreamController.stream.listen((loaderStatus){
      setState(() {
        isLoading = loaderStatus;
      });
    });
    super.initState();
  }

  Future<bool> _willPopCallback() async {

    return true;
  }

  Widget Processing(bool _processing) {
    return Visibility(
      visible: _processing && widget.showLoading,
      child: Positioned(
        child: Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Center(
            heightFactor: 0.2,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).backgroundColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(1, 1)
                    )
                  ]
              ),
              child: CircularProgressIndicator(
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        WillPopScope(
          child: widget.builder(requestScheduler),
          onWillPop: _willPopCallback,
        ),
        Processing(isLoading),
      ],
    );
  }
}
