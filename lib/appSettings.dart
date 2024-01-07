import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData themeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,  // Set the overall theme brightness to dark

  appBarTheme: const AppBarTheme(
    centerTitle: true,
    foregroundColor: Color(0xffFCFCFC),
    backgroundColor: Color(0xff171717),
  ),

  primaryColor: Colors.black,
  scaffoldBackgroundColor: const Color(0xFF2C2D30),

  fontFamily: GoogleFonts.montserrat().fontFamily,
  textTheme: const TextTheme(

    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
    bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),

    headlineLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white,),
    headlineMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white,),
    headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white,),
  ),
);