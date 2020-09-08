import 'package:ehr/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final Function onpressed;

  const CustomButton(this.text, this.onpressed, {this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      onPressed: onpressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      color: Theme.of(context).primaryColor,
      child: CustomText(
        text,
        fontweight: fontWeight,
      ),
    );
  }
}
