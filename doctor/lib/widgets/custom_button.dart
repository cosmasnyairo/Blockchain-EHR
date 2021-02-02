import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final Function onpressed;
  final Color backgroundcolor;
  const CustomButton(this.text, this.onpressed, {this.backgroundcolor});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onpressed,
      child: CustomText(text),
      color: backgroundcolor,
      disabledColor: backgroundcolor,
    );
  }
}
