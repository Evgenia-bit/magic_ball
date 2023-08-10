//цвета приложения
import 'package:flutter/material.dart';

extension AppColors on ColorScheme {
  static Color darkPrimaryColor = const Color.fromRGBO(56, 186, 227, 1);
  static Color lightPrimaryColor = const Color.fromRGBO(108, 105, 140, 1);

  Color get magicBallTextColor =>
      brightness == Brightness.light
          ? const Color.fromRGBO(108, 105, 140, 1)
          : Colors.white;

  Color get bottomTextColor =>
      brightness == Brightness.light
          ? const Color.fromRGBO(108, 105, 140, 1)
          : const Color.fromRGBO(114, 114, 114, 1);

  Color get backgroundTopColor =>
      brightness == Brightness.light
          ? Colors.white
          : const Color.fromRGBO(16, 12, 44, 1);

  Color get backgroundBottomColor =>
      brightness == Brightness.light
          ? const Color.fromRGBO(210, 210, 255, 1)
          : const Color.fromRGBO(0, 0, 2, 1);
}