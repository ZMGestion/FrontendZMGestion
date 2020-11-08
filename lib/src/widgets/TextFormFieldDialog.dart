import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldDialog extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final String initialValue;
  final bool disabled;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final String Function(String) validator;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final Widget icon;
  final int maxLines;
  final Widget suffixIcon;

  const TextFormFieldDialog({
    Key key, 
    this.labelText, 
    this.hintText,
    this.obscureText = false,
    this.initialValue,
    this.disabled = false,
    this.inputFormatters,
    this.controller, 
    this.validator,
    this.hintStyle,
    this.labelStyle,
    this.textStyle,
    this.icon,
    this.maxLines,
    this.suffixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        initialValue: initialValue,
        enabled: !disabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: hintStyle,
          labelStyle: labelStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          icon: icon != null ? icon : null,
          suffixIcon: suffixIcon != null ? suffixIcon : null
        ),
        style: textStyle,

    );
  }
}