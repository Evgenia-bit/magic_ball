import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/core/styles/colors.dart';
import 'package:surf_practice_magic_ball/core/utils/adaptability_manager.dart';


//режим темы в текстовом формате (чтобы правильно определять пути до папок с картинками для разных тем)
extension ThemeMode on ThemeData {
  String get themeMode => brightness.toString().split('.')[1];
}

//данная функция позволяет создать светлую или темную тему
ThemeData theme({bool dark = false}) {
  var scheme = dark
      ? const ColorScheme.dark()
          .copyWith(primary: AppColors.darkPrimaryColor)
      : const ColorScheme.light()
          .copyWith(primary: AppColors.lightPrimaryColor);


  return ThemeData(
    colorScheme: scheme,
    primaryColor: scheme.primary,
    useMaterial3: true,
    textTheme: TextTheme(
      //стиль для текста внутри шара
      displayLarge: TextStyle(
        fontSize: AdaptabilityManager.magicBallFontSize,
        color: scheme.magicBallTextColor,
      ),
      //стиль для текста внизу экрана
      displaySmall: TextStyle(
        color: scheme.bottomTextColor,
        fontSize: AdaptabilityManager.bottomFontSize,
        fontWeight: FontWeight.w400,
      ),
      //стиль шапки панели настроек
      titleMedium: TextStyle(
        fontSize: AdaptabilityManager.settingsTitleFontSize,
      ),

      bodyMedium: TextStyle(
        fontSize: AdaptabilityManager.settingsBodyMediumFontSize,
      ),
      bodySmall: TextStyle(
        fontSize: AdaptabilityManager.settingsBodySmallFontSize,
        color: scheme.bottomTextColor,
      ),
    ),
  );
}
