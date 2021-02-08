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
  final bool dropdown;
  final String hinttext;
  final Function onchanged;
  final List<DropdownMenuItem> items;
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
    this.dropdown = false,
    this.hinttext,
    this.onchanged,
    this.items,
  });
  @override
  Widget build(BuildContext context) {
    return dropdown
        ? DropdownButtonFormField(
            focusNode: focusNode,
            decoration: InputDecoration(
              prefixIcon: icondata == null ? null : Icon(icondata),
              hintText: hinttext,
            ),
            validator: validator,
            items: items,
            onChanged: onchanged,
          )
        : TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardtype,
            initialValue: initialvalue,
            decoration: InputDecoration(
              prefixIcon: icondata == null
                  ? null
                  : Icon(
                      icondata,
                    ),
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
