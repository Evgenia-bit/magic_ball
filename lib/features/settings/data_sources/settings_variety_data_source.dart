import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/features/navigation/settings_sheet_navigation.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/settings_variety.dart';


final settingsVarietyDataSource = [
  SettingVariety(
    Icons.color_lens,
    'Цвет',
    SettingsNavigationPageNames.color,
  ),
  SettingVariety(
    Icons.animation,
    'Анимация шара',
    SettingsNavigationPageNames.ballAnimation,
  ),
  SettingVariety(
    Icons.text_fields,
    'Анимация текста',
    SettingsNavigationPageNames.textAnimation,
  ),
  SettingVariety(
    Icons.surround_sound,
    'Звук уведомления',
    SettingsNavigationPageNames.answerSound,
  ),
  SettingVariety(
    Icons.record_voice_over,
    'Голосовой ассистент',
    SettingsNavigationPageNames.voiceAssistant,
  ),
];
