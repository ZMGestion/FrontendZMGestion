import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';

import '../../../main.dart';

class ZMBreadCrumb extends StatefulWidget {
  final Map<String, String> config;

  const ZMBreadCrumb({Key key, this.config}) : super(key: key);
  @override
  _ZMBreadCrumbState createState() => _ZMBreadCrumbState();
}

class _ZMBreadCrumbState extends State<ZMBreadCrumb> {
  Map<String, String> config = new Map<String, String>();
  List<BreadCrumbItem> items = [];

  @override
  void initState() {
    // TODO: implement initState
    if (widget.config != null){
      config.addAll(widget.config);
      config.forEach((key, value) {
        var breadcrumb = new BreadCrumbItem(
            content: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                key,
                style: TextStyle(
                      color: value != null ? Theme.of(mainContext).primaryColor.withOpacity(0.45) : Theme.of(mainContext).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800
                    ),
              ),
            ),
            onTap: value != null ?(){
              final NavigationService _navigationService = locator<NavigationService>();
                _navigationService.navigateTo(value);
            }: null 
          );
        items.add(breadcrumb);
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BreadCrumb(
      items: items,
      divider: Icon(
        Icons.keyboard_arrow_right,
        color: Colors.black54,
      ),
    );
  }
}