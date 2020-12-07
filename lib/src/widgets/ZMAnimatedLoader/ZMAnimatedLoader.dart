import "package:flare_flutter/flare_actor.dart";
import 'package:flare_flutter/flare_controller.dart';
import "package:flutter/material.dart";

class ZMAnimatedLoader extends StatefulWidget {
  final FlareController controller;
  final double height;
  final double width;

  ZMAnimatedLoader({
    this.controller,
    this.height,
    this.width
  });


  @override
  _ZMAnimatedLoaderState createState() => _ZMAnimatedLoaderState();
}

class _ZMAnimatedLoaderState extends State<ZMAnimatedLoader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FlareActor(
        "Loader.flr",
        controller: widget.controller,
        shouldClip: false,
        alignment:Alignment.center,
        fit:BoxFit.fill, 
        animation:"linear"
      ),
    );
  }
}