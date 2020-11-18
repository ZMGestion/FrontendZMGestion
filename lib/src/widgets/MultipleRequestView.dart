import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/themes/AppTheme.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class MultipleRequestView extends StatefulWidget {
  final String title;
  final List<Models> models;
  final DoMethodConfiguration doMethodConfiguration;
  final Services service;
  final Map<String, dynamic> Function(Map<String, dynamic> mapModel) payload;
  final Widget Function(Map<String, dynamic>) itemBuilder;
  final Function onFinished;

  const MultipleRequestView({
    Key key, 
    this.models, 
    this.title = "",
    this.doMethodConfiguration, 
    this.service,
    this.payload,
    this.itemBuilder,
    this.onFinished
  }) : super(key: key);

  @override
  _MultipleRequestViewState createState() => _MultipleRequestViewState();
}

class _MultipleRequestViewState extends State<MultipleRequestView> {
  List<RequestStatus> _requestStatus = new List<RequestStatus>();
  bool running = false;
  bool stopped = false;
  bool finished = false;
  int currentIndex = 0;
  double _height = 0;
  int stoppedIndex;

  initState(){
    widget.models.forEach((model) {
      _requestStatus.add(RequestStatus.PENDING);
    });
    _height = 40.0 * widget.models.length + 26;
    super.initState();
  }

  _sendRequests() async{
    if(widget.service != null && widget.doMethodConfiguration != null){
      int index = 0;
      int continueIndex = stoppedIndex != null ? stoppedIndex : 0;
      await Future.forEach(widget.models, (model) async{
        if(!stopped){
          if(index >= continueIndex){
            setState(() {
              _requestStatus[index] = RequestStatus.SENDED;  
            });
            setState(() {
              currentIndex = index;
            });
            widget.doMethodConfiguration.payload = widget.payload(model.toMap());
            DoMethodConfiguration doMethodConfiguration = DoMethodConfiguration(
              method: widget.doMethodConfiguration.method,
              path: widget.doMethodConfiguration.path,
              actionsConfiguration: widget.doMethodConfiguration.actionsConfiguration,
              attributes: widget.doMethodConfiguration.attributes,
              authorizationHeader: widget.doMethodConfiguration.authorizationHeader,
              errorMessage: widget.doMethodConfiguration.errorMessage,
              keyboardContext: widget.doMethodConfiguration.keyboardContext,
              loadingMessage: widget.doMethodConfiguration.loadingMessage,
              model: widget.doMethodConfiguration.model,
              payload: widget.payload != null ? widget.payload(model.toMap()) : null,
              requestConfiguration: null, //para no mostrar mensajes
              showMessages: false,
              scheduler: widget.doMethodConfiguration.scheduler,
              successMessage: widget.doMethodConfiguration.successMessage
            );
            await widget.service.doMethod(doMethodConfiguration).then(
              (response){
                setState(() {
                  _requestStatus[index] = response.status;
                });
              }
            );
          }
        }else{
          if(stoppedIndex == null){
            setState(() {
              stoppedIndex = index;  
            });
          }
        }
        index++;
      });
      setState(() {
        finished = true;
        running = false;
      });
    }
  }

  _stopRequests(){
    if(running){
      setState(() {
        stoppedIndex = null;
        stopped = true;
        running = false;
      });
    }else{
      setState(() {
        stopped = false;
        running = false;
        finished = true;
      });
    }
  }



  Widget _statusIcon(RequestStatus status){
    switch(status){
      case RequestStatus.PENDING:
        return Icon(Icons.panorama_fish_eye);
      case RequestStatus.SENDED:
        return Container(
          height: 20,
          width: 20,
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 1,)
          )
        );
      case RequestStatus.ERROR:
        return Icon(Icons.close);
      case RequestStatus.SUCCESS:
        return Icon(Icons.check);
    }
  }

  _close(BuildContext context){
    if(currentIndex > 0 || finished){
      if(widget.onFinished != null){
        widget.onFinished();
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      elevation: 1.5,
      scrollable: true,
      actionsPadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: AlertDialogTitle(
        title: widget.title,
        titleColor: Theme.of(context).primaryColor,
      ),
      content: Column(
        children: [
          Container(
            height: (_height > SizeConfig.blockSizeVertical * 60 ? SizeConfig.blockSizeVertical * 60 : _height),
            width: SizeConfig.blockSizeHorizontal * 35,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            color: Colors.black.withOpacity(0.07),
            child: ListView.builder(
              itemCount: widget.models != null ? widget.models.length : 0,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Opacity(
                        opacity: currentIndex != null && index == currentIndex ? 1 : 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Icon(
                            Icons.arrow_right,
                            color: Colors.black54,
                            size: 18,
                          ),
                        )
                      ),
                      Expanded(
                        child: widget.itemBuilder(widget.models.elementAt(index).toMap()),
                      ),
                      _statusIcon(_requestStatus[index]),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZMStdButton(
              color: Theme.of(context).primaryColor,
              text: Text(
                (stopped && finished) ? "Continuar" : (currentIndex == (widget.models.length - 1) ? "Finalizar" : "Aceptar"),
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              icon: Icon(
                Icons.check,
                color: Colors.white
              ),
              onPressed: running ? null : (){
                if((!finished && !stopped) || (stopped && finished)){
                  setState(() {
                    stopped = false;
                    finished = false;
                    running = true;
                  });
                  _sendRequests();
                }else{
                  _close(context);
                }
              },
            ),
            SizedBox(
              width: 15
            ),
            ZMTextButton(
              color: Theme.of(context).primaryColor,
              text: (stopped && !finished) ? "Cancelando" : "Cancelar",
              onPressed: (stopped && !finished) ? null : (){
                if(!running){
                  _close(context);
                }else{
                  _stopRequests();
                }
              },
              outlineBorder: false,
            )
          ],
        )
        ],
      )
    );
  }
}