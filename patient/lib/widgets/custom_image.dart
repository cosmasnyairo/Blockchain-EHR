import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/customtheme.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final BoxFit boxFit;
  CustomImage(this.path, this.boxFit);
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeProvider>(context, listen: false);

    return Image.asset(
      path,
      fit: boxFit,
      color: path != 'assets/success.png'
          ? theme.darkthemechosen
              ? Theme.of(context).accentColor
              : null
          : null,
      frameBuilder: (BuildContext context, Widget child, int frame,
          bool wasSynchronouslyLoaded) {
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );
      },
    );
  }
}
