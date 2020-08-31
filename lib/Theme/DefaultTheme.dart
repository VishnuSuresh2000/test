import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData defaultTheme = ThemeData(
    primaryColor: Colors.white,
    backgroundColor: Colors.white,
    accentColor: Color(0xff2BC48A),
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
        bodyText2: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 14)),
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
        iconTheme: IconThemeData(color: Color(0xff5B5B5B)),
        actionsIconTheme: IconThemeData(color: Color(0xff5B5B5B))),
    tabBarTheme: TabBarTheme(
        labelColor: Color(0xff2BC48A),
        labelStyle: TextStyle(
            fontFamily: GoogleFonts.openSans().fontFamily,
            fontSize: 15.0,
            fontWeight: FontWeight.normal),
        unselectedLabelColor: Color(0xff5B5B5B),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(color: Colors.transparent)));
