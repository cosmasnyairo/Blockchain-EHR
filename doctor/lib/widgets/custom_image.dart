import 'package:doctor/theme/customtheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    );
  }
}
