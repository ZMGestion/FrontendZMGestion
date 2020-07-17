import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zmgestion/src/views/structure/ZMAppBar.dart';
import 'package:zmgestion/src/views/structure/ZMDrawer.dart';
import 'package:zmgestion/src/views/structure/ZMNavigationBar.dart';
import 'package:custom_navigation_drawer/custom_navigation_drawer.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class BodyTemplate extends StatefulWidget {
  final Widget child;
  const BodyTemplate({Key key, this.child}) : super(key: key);

  @override
  _BodyTemplateState createState() => _BodyTemplateState();
}

class _BodyTemplateState extends State<BodyTemplate> {
  FocusNode bodyFocusNode;
  @override
  void initState() {
    // TODO: implement initState
    bodyFocusNode = new FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        body: GestureDetector(
          onTap:(){
            FocusScope.of(context).requestFocus(bodyFocusNode);
          },
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Scaffold(
                  appBar: ZMAppBar(
                  ),
                  backgroundColor:
                      Theme.of(context).backgroundColor,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    child: widget.child,
                  ),
                ),
              ),
              ZMDrawer(
                context: context,
                maxWidth: 280,
                minWidth: 80,
              ),
            ],
          ),
        )
      ),
    );
  }
}
