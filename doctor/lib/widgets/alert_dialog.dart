import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final bool success;
  final String message;
  CustomAlertDialog({this.success, this.message});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Container(
        width: width * 0.6,
        child: Image.asset(
          success ? 'assets/success.gif' : 'assets/error.gif',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        SizedBox(height: 10),
        FlatButton(
          child: Text(
            'Okay',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
