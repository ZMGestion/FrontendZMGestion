import 'package:flutter/material.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';

class DropDownMap extends StatefulWidget {
  final bool isExpanded;
  final Map<String, String> map;
  final Widget hint;
  final Function(dynamic) onChanged;
  final String initialValue;
  final bool addAllOption;
  final String addAllText;
  final String addAllValue;

  const DropDownMap({
    Key key, 
    this.isExpanded = true,
    this.map,
    this.onChanged,
    this.initialValue,
    this.hint = const Text(
      "Seleccione una opción"
    ), 
    this.addAllOption = false, 
    this.addAllText = "All", 
    this.addAllValue
  }) : super(key: key);

  @override
  _DropDownMapState createState() => _DropDownMapState();
}

class _DropDownMapState extends State<DropDownMap> {
  List<DropdownMenuItem> items = new List<DropdownMenuItem>();
  String selectedValue;

  @override
  void initState() { 
    super.initState();
    selectedValue = widget.initialValue;
    if(widget.addAllOption){
      items.add(
        DropdownMenuItem<String>(
          value: widget.addAllValue,
          child: Text(widget.addAllText),
        )
      );
    }
    widget.map.forEach((key, value) {
      items.add(
        DropdownMenuItem<String>(
          value: key,
          child: Text(value),
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      key: Key(selectedValue),
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      items: items,
      hint: widget.hint,
      value: selectedValue,
      onChanged: (value){
        setState(() {
          selectedValue = value;
        });
        if(widget.onChanged != null){
          widget.onChanged(value);
        }
      }
    );
  }
}