import 'package:flutter/material.dart';

import '../widgets/custom_image.dart';

class LibrariesUsed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    return LicensePage(
      applicationIcon: Container(
        height: deviceheight * 0.2,
        padding: EdgeInsets.all(20),
        child: CustomImage('assets/background.png', BoxFit.contain),
      ),
      applicationName: 'Ehr Kenya',
      applicationVersion: 'Version 1.0',
    );
  }
}
