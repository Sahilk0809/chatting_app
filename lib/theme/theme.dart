import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.grey[700]!,
    onPrimary: Colors.grey[400]!,
    secondary: Colors.grey[800]!,
    onSecondary: Colors.grey[700]!,
    error: Colors.red,
    onError: Colors.red[800]!,
    surface: Colors.white,
    onSurface: Colors.grey[700]!,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.grey[100]!,
    onPrimary: Colors.grey[400]!,
    secondary: Colors.grey[200]!,
    onSecondary: Colors.grey[700]!,
    error: Colors.red,
    onError: Colors.red[800]!,
    surface: Colors.black,
    onSurface: Colors.white,
  ),
);
