import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontsize;
  final Color color;
  final TextAlign alignment;
  final FontWeight fontweight;
  final TextOverflow overflow;
  final FontStyle fontStyle;
  CustomText(
    this.text, {
    this.color,
    this.fontsize,
    this.alignment,
    this.fontweight,
    this.overflow,
    this.fontStyle,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      overflow: overflow,
      style: GoogleFonts.montserrat(
          fontStyle: fontStyle,
          fontSize: fontsize,
          color: color,
          fontWeight: fontweight),
    );
  }
}
