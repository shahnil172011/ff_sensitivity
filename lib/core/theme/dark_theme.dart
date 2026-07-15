import 'package:flutter/material.dart';
import 'app_theme.dart';

ThemeData darkTheme = appTheme.copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF05080F),
  cardTheme: const CardTheme(
    color: Color(0xFF0D1326),
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);