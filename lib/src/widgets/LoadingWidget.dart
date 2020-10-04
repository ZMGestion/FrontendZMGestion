import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:12.5),
          child: Container(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
