import 'package:flutter/material.dart';
import 'package:royaltouch/config/colors.dart';

class AppTheme {
  static ThemeData getLightThemeData() => ThemeData(
        primaryColor: bluePrimary,
        fontFamily: 'Lato',
        cardColor: Colors.white,
        canvasColor: bg,
        // appBarTheme: const AppBarTheme(
        //     // brightness: Brightness.light,
        //     ),
      );
  static ThemeData getDarkThemeData() => ThemeData();
}
