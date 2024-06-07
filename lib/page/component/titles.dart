import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class H1 extends StatelessWidget {
  final String text;

  const H1(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold));
  }
}

class H2 extends StatelessWidget {
  final String text;
  final Color? color;

  const H2(this.text, {this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: (color ?? Colors.black)),
      softWrap: false,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class H3 extends StatelessWidget {
  final String text;

  const H3(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold));
  }
}

class H4 extends StatelessWidget {
  final String text;
  final Color? color;

  const H4(this.text, {this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black));
  }
}
