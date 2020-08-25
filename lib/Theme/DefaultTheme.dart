import 'package:flutter/material.dart';

ThemeData defaultTheme = ThemeData(
    primaryColor: Colors.white,
    backgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: Colors.white,
    ),
    textTheme: TextTheme(
        caption: TextStyle(
          color: Color(0xffcc8053),
          fontFamily: 'SourceSansPro',
          fontSize: 18.0,
        ),
        subtitle2: TextStyle(
          color: Colors.green,
          fontFamily: 'SourceSansPro',
          fontSize: 20.0,
        ),
        subtitle1: TextStyle(
          color: Colors.redAccent,
          fontFamily: 'SourceSansPro',
          fontSize: 20.0,
        ),
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
        )),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
        color: Colors.white,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 30.0,
            color: Color(0xff545d68),
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xff545d68))),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.green,
      labelStyle: TextStyle(fontFamily: 'SourceSansPro', fontSize: 21.0),
      unselectedLabelColor: Color(0xffcdcdcd),
    ));
