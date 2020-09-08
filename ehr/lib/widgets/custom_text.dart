import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontsize;
  final Color color;
  final TextAlign alignment;
  final FontWeight fontweight;

  CustomText(this.text,
      {this.color, this.fontsize, this.alignment, this.fontweight});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      style: GoogleFonts.montserrat(
          fontSize: fontsize, color: color, fontWeight: fontweight),
    );
  }
}
