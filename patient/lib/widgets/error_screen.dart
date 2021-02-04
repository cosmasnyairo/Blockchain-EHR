import 'package:flutter/material.dart';

import 'custom_image.dart';
import 'custom_text.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(30),
          height: deviceheight * 0.5,
          child: CustomImage('assets/404.png', BoxFit.contain),
        ),
        SizedBox(height: 20),
        CustomText(
          'An Error Occured!',
          alignment: TextAlign.center,
          fontsize: 20,
          color: Theme.of(context).errorColor,
        ),
        SizedBox(height: 20),
        CustomText(
          'Server may be offline, please retry after some time',
          alignment: TextAlign.center,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
