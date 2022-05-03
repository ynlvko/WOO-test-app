import 'package:flutter/material.dart';

final defaultThemeData = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Colors.blueGrey,
    secondary: Colors.amber,
  ),
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      border: Border.all(color: Colors.amber),
      borderRadius: BorderRadius.circular(4),
    ),
  ),
  dividerColor: Colors.amber,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.amber,
        width: 2,
      ),
    ),
  ),
);
