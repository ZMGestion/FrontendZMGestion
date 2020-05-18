import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zmgestion/src/views/structure/ZMAppBar.dart';
import 'package:zmgestion/src/views/structure/ZMDrawer.dart';
import 'package:zmgestion/src/views/structure/ZMNavigationBar.dart';

class BodyTemplate extends StatelessWidget {
  final Widget child;
  const BodyTemplate({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        /*drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
            ? NavigationDrawer()
            : null,*/
        drawer: ZMDrawer(),
        backgroundColor: Colors.white,
        appBar: ZMAppBar(),
        body: Column(
            children: <Widget>[
              ZMNavigationBar(),
              Expanded(
                child: child,
              )
            ],
          )
      ),
    );
  }
}