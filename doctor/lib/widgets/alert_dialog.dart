import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'custom_image.dart';

class CustomAlertDialog extends StatelessWidget {
  final bool success;
  final String message;
  CustomAlertDialog({this.success, this.message});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Container(
        height: height * 0.33,
        width: width * 0.33,
        child: CustomImage(
          success ? 'assets/success.png' : 'assets/error.png',
          BoxFit.contain,
        ),
      ),
      content: CustomText(message, alignment: TextAlign.center),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actionsPadding: EdgeInsets.all(10),
      actions: [
        CustomButton(
          'Dismiss',
          () {
            Navigator.of(context).pop();
          },
          backgroundcolor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
