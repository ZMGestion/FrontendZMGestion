import 'package:flutter/material.dart';

class FilterChoiceChip extends StatefulWidget {
  final String text;
  final EdgeInsetsGeometry padding;
  final Function(bool) onSelected;
  final bool initialValue;

  const FilterChoiceChip({
    Key key, 
    this.text = "",
    this.padding = const EdgeInsets.only(left: 6),
    this.onSelected,
    this.initialValue = false
  }) : super(key: key);

  @override
  _FilterChoiceChipState createState() => _FilterChoiceChipState();
}

class _FilterChoiceChipState extends State<FilterChoiceChip> {
  bool _selected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: ChoiceChip(
        label: Text(
          widget.text
        ),
        selected: _selected,
        onSelected: (value){
          setState(() {
            _selected = value;
          });
          if(widget.onSelected != null){
            widget.onSelected(value);
          }
        }
      ),
    );
  }
}