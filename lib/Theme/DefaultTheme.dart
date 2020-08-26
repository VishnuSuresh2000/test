import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData defaultTheme = ThemeData(
    primaryColor: Colors.white,
    backgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: Colors.white,
    ),
    iconTheme: IconThemeData(color: Color(0xff5B5B5B)),
    textTheme: TextTheme(
      caption: TextStyle(
        color: Color(0xff5B5B5B),
        fontFamily: GoogleFonts.openSans().fontFamily,
        fontSize: 18.0,
      ),
      subtitle2: TextStyle(
        color: Colors.green,
        fontFamily: 'SourceSansPro',
        fontSize: 20.0,
      ),
      // subtitle1: TextStyle(
      //   color: Colors.redAccent,
      //   fontFamily: 'SourceSansPro',
      //   fontSize: 20.0,
      // ),
      headline1: TextStyle(
        color: Colors.blueAccent,
        fontFamily: 'SourceSansPro',
        fontSize: 20.0,
      ),
      headline2: TextStyle(
        fontFamily: 'SourceSansPro',
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyText1: TextStyle(
          fontFamily: GoogleFonts.openSans().fontFamily,
          fontWeight: FontWeight.w600,
          color: Colors.black, //semibold
          fontSize: 15),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
        color: Colors.white,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 25.0,
            color: Color(0xff5B5B5B),
            fontFamily: GoogleFonts.openSans().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xff5B5B5B))),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.green,
      labelStyle: TextStyle(fontFamily: 'SourceSansPro', fontSize: 21.0),
      unselectedLabelColor: Color(0xffcdcdcd),
    ));
