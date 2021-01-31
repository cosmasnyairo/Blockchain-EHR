import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String initialvalue;
  final IconData icondata;
  final String labeltext;
  final TextInputAction textInputAction;
  final Function validator;
  final Function onsaved;
  final FocusNode focusNode;
  final Function onfieldsubmitted;
  final TextInputType keyboardtype;
  final int maxlines;
  final TextEditingController controller;
  final bool obscuretext;
  const CustomFormField({
    this.initialvalue,
    this.icondata,
    this.labeltext,
    this.textInputAction,
    this.validator,
    this.onsaved,
    this.onfieldsubmitted,
    this.focusNode,
    this.obscuretext = false,
    this.keyboardtype,
    this.maxlines,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardtype,
      initialValue: initialvalue,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: icondata == null
            ? null
            : Icon(icondata, size: 25, color: Theme.of(context).primaryColor),
        labelText: labeltext,
      ),
      textInputAction: textInputAction,
      validator: validator,
      onSaved: onsaved,
      maxLines: maxlines == null ? null : maxlines,
      obscureText: obscuretext,
      onFieldSubmitted: onfieldsubmitted,
    );
  }
}
