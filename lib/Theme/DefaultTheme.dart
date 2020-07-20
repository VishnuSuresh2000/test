import 'package:flutter/material.dart';

ThemeData defaultTheme = ThemeData(
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
