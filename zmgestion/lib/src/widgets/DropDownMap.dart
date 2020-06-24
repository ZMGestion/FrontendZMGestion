import 'package:flutter/material.dart';

class DropDownMap extends StatelessWidget {
  final bool isExpanded;
  final Map<String, String> map;
  final Widget hint;
  final Function(dynamic) onChanged;

  const DropDownMap({
    Key key, 
    this.isExpanded = true,
    this.map,
    this.onChanged,
    this.hint = const Text(
      "Seleccione una opción"
    )
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      items: map.keys.map((String key){
        return DropdownMenuItem<String>(
          value: key,
          child: Text(map[key]),
        );
      }).toList(),
      hint: Text("Estado civil"),
      onChanged: onChanged
    );
  }
}