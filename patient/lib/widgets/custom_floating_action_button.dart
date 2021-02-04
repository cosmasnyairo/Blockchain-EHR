import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final String labelText;
  final IconData icondata;
  final Function onpressed;
  final Color color;
  CustomFAB(this.labelText, this.icondata, this.onpressed, {this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FloatingActionButton.extended(
        label: Text(labelText),
        icon: Icon(icondata),
        heroTag: null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: onpressed,
      ),
    );
  }
}
