import 'package:aplikasi/page/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          alignment: Alignment.center,
          padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          textStyle: WidgetStatePropertyAll(GoogleFonts.inter()),
        )),
        tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                GoogleFonts.inter(fontWeight: FontWeight.normal),
            indicator: const BoxDecoration(
              shape: BoxShape.rectangle,
            )),
      ),
      home: const Login(),
    );
  }
}
