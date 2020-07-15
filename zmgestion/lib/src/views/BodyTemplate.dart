import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zmgestion/src/views/structure/ZMAppBar.dart';
import 'package:zmgestion/src/views/structure/ZMDrawer.dart';
import 'package:zmgestion/src/views/structure/ZMNavigationBar.dart';
import 'package:custom_navigation_drawer/custom_navigation_drawer.dart';

class BodyTemplate extends StatelessWidget {
  final Widget child;
  const BodyTemplate({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          drawer: Drawer(),
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Row(
                children: [
                  ZMDrawer(
                    context: context,
                    maxWidth: 300,
                    minWidth: 80,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(25))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Scaffold(
                              appBar: ZMAppBar(),
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              body: child,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
