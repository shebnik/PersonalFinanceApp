import 'package:flutter/material.dart';

class AppTheme {
  static final primarySwatch = MaterialColor(primary.value, colors);

  static final Map<int, Color> colors = {
    50: const Color.fromRGBO(118, 69, 217, .1),
    100: const Color.fromRGBO(118, 69, 217, .2),
    200: const Color.fromRGBO(118, 69, 217, .3),
    300: const Color.fromRGBO(118, 69, 217, .4),
    400: const Color.fromRGBO(118, 69, 217, .5),
    500: const Color.fromRGBO(118, 69, 217, .6),
    600: const Color.fromRGBO(118, 69, 217, .7),
    700: const Color.fromRGBO(118, 69, 217, .8),
    800: const Color.fromRGBO(118, 69, 217, .9),
    900: const Color.fromRGBO(118, 69, 217, 1),
  };

  static const primary = Color.fromRGBO(118, 69, 217, 1);
  static const primaryGreen = Color.fromRGBO(1, 249, 156, 1);
  static const yellow = Color.fromRGBO(255, 233, 91, 1);
  static const red = Color.fromRGBO(249, 1, 85, 1);

  static const shadow = Color.fromRGBO(0, 0, 0, 0.16);

  static Color black(double opacity) => Color.fromRGBO(0, 0, 0, opacity);
}
