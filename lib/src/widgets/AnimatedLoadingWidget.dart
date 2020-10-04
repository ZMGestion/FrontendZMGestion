import 'package:flutter/material.dart';
import 'package:zmgestion/src/widgets/ZMAnimatedLoader/ZMAnimatedLoader.dart';

class AnimatedLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:25),
          child: Container(
            width: 75,
            height: 75,
            child: ZMAnimatedLoader(),
          ),
        ),
      ],
    );
  }
}
