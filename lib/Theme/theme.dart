import 'package:flutter/material.dart';

class AppTheme{
  static const Color primary = Colors.green;
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    //Color primario
    primaryColor: Colors.indigo,
    //AppBar Theme
    appBarTheme: const AppBarTheme(
      color:primary,
      elevation: 0
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black54)),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),
        topRight: Radius.circular(10))
      )
    )
  );

  // static final ThemeData darkTheme = ThemeData.light().copyWith(
  //   //Color primario
  //   primaryColor: Colors.indigo,
  //   //AppBar Theme
  //   appBarTheme: const AppBarTheme(
  //     color:primary,
  //     elevation: 0
  //   ),
  //   textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.deepOrange)),
  //   inputDecorationTheme: const InputDecorationTheme(
  //     floatingLabelStyle: TextStyle(color: primary),
  //     enabledBorder: OutlineInputBorder(
  //       borderSide: BorderSide(color: primary),
  //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),
  //       topRight: Radius.circular(10))
  //     )
  //   )
  // );
}