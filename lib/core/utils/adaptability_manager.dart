import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop;
}

//данный класс позволяет определять размеры элементов и текст внизу экрана для разных платформ
class AdaptabilityManager {
  static DeviceType get deviceType {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      final flutterView =
          WidgetsBinding.instance.platformDispatcher.views.single;
      return MediaQueryData.fromView(flutterView).size.shortestSide < 600
          ? DeviceType.mobile
          : DeviceType.tablet;
    }
    return DeviceType.desktop;
  }

  static double get magicBallSize => switch (deviceType) {
        DeviceType.mobile => 350,
        DeviceType.tablet || DeviceType.desktop => 665,
      };

  static double get bottomEllipseWidth => switch (deviceType) {
        DeviceType.mobile => 120,
        DeviceType.tablet || DeviceType.desktop => 225,
      };

  static double get bottomShadowWidth => switch (deviceType) {
        DeviceType.mobile => 260,
        DeviceType.tablet || DeviceType.desktop => 550,
      };

  static double get magicBallFontSize => switch (deviceType) {
        DeviceType.mobile => 32,
        DeviceType.tablet || DeviceType.desktop => 56,
      };

  static double get bottomFontSize => switch (deviceType) {
        DeviceType.mobile => 16,
        DeviceType.tablet || DeviceType.desktop => 32,
      };

  static double get settingsTitleFontSize => switch (deviceType) {
        DeviceType.mobile => 20,
        DeviceType.tablet || DeviceType.desktop => 36,
      };

  static double get settingsBodyMediumFontSize => switch (deviceType) {
        DeviceType.mobile => 14,
        DeviceType.tablet || DeviceType.desktop => 30,
      };

  static double get settingsBodySmallFontSize => switch (deviceType) {
        DeviceType.mobile => 12,
        DeviceType.tablet || DeviceType.desktop => 24,
      };

  static String get bottomText {
    String text = 'Нажмите на шар';
    if (deviceType == DeviceType.desktop) {
      return text;
    }
    return '$text или потрясите ${deviceType == DeviceType.mobile ? 'телефон' : 'планшет'}';
  }
}
