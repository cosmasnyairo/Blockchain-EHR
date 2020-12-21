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
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      keyboardType: keyboardtype,
      initialValue: initialvalue,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(icondata, size: 25, color: Theme.of(context).primaryColor),
        labelText: labeltext,
      ),
      textInputAction: textInputAction,
      validator: validator,
      onSaved: onsaved,
      obscureText: obscuretext,
      onFieldSubmitted: onfieldsubmitted,
    );
  }
}
