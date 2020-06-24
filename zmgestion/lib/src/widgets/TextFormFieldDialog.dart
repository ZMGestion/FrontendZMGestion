import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldDialog extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final String Function(String) validator;

  const TextFormFieldDialog({
    Key key, 
    this.labelText, 
    this.hintText,
    this.obscureText = false,
    this.inputFormatters,
    this.controller, 
    this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        ),
    );
  }
}