import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

enum MessageType{
  Error,
  Success,
  Info
}

class ColorMessage{
  final MessageType messageType;

  const ColorMessage({this.messageType});

  Color text(){
    switch(this.messageType){
      case MessageType.Info:
        return Color(0xff2c6666);
      case MessageType.Success:
        return Color(0xff7ea830);
      case MessageType.Error:
        return Color(0xff89351e);
    }
    return Colors.black;
  }

  Color background(){
    switch(this.messageType){
      case MessageType.Info:
        return Color(0xff8ecece);
      case MessageType.Success:
        return Color(0xffd6f2a2);
      case MessageType.Error:
        return Color(0xffef9177);
    }
    return Colors.black87;
  }
}

StreamController<Message> messageStreamController = StreamController<Message>();
Stream<Message> messagesStream = messageStreamController.stream;

class Message{
  final String message;
  final Color textColor;
  final Color backgroundColor;

  const Message({
    this.message,
    this.textColor,
    this.backgroundColor
  });
}


class ScreenMessage extends StatefulWidget{

  final Widget child;
  static StreamController loadingStreamController = StreamController<bool>();

  const ScreenMessage({
    this.child,
  });

  static push(String message, MessageType messageType){
    Widget toast(Message message){
      return Container(
        margin: EdgeInsets.only(top: 0),
        constraints: BoxConstraints(minWidth: SizeConfig.blockSizeHorizontal*20, maxWidth: SizeConfig.blockSizeHorizontal*80),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              print("Tap");
            },
            child: Container(
              decoration: BoxDecoration(
                  color: message.backgroundColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        offset: Offset(1,1),
                        color: Colors.black.withOpacity(0.05)
                    )
                  ]
              ),
              padding: EdgeInsets.all(15),
              child: Text(
                message.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: message.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'sans-serif',
                    decoration: TextDecoration.none
                ),
              ),
            ),
          ),
        ),
      );
    }

    showToastWidget(
        toast(
            Message(
              message: message,
              textColor: ColorMessage(messageType: messageType).text(),
              backgroundColor: ColorMessage(messageType: messageType).background(),
            )
        ),
        duration: Duration(milliseconds: 1500 + message.length * 30),
        position: ToastPosition.top
    );

  }

  @override
  _ScreenMessageState createState() => _ScreenMessageState();
}

class _ScreenMessageState extends State<ScreenMessage> {

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    ScreenMessage.loadingStreamController.stream.listen((loadingState){
      setState(() {
        loading = loadingState;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SizeConfig().init(context);
        return Stack(
          children: <Widget>[
            widget.child,
            Visibility(
              visible: loading,
              child: Center(
                child: Container(
                  width: SizeConfig.blockSizeHorizontal*15,
                  height: SizeConfig.blockSizeHorizontal*15,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.86),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).iconTheme.color,
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
  }
}
