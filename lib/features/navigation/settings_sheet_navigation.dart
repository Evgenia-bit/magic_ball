import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/widgets/sound_settings_page.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/widgets/ball_animation_settings_page.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/widgets/color_settings_page.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/widgets/main_settings_page.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/widgets/text_animation_settings_page.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/widgets/voice_assistant_settings_page.dart';

abstract class SettingsNavigationPageNames {
  static const main = '/settings';
  static const color = '/settings/color';
  static const ballAnimation = '/settings/ball_animation';
  static const textAnimation = '/settings/text_animation';
  static const voiceAssistant = '/settings/voice_assistant';
  static const answerSound = '/settings/answer_sound';
}

abstract class SettingsNavigation {
  static const pages = <String, Widget>{
    SettingsNavigationPageNames.main: MainSettingsPage(),
    SettingsNavigationPageNames.color: ColorSettingsPage(),
    SettingsNavigationPageNames.ballAnimation: BallAnimationSettingsPage(),
    SettingsNavigationPageNames.textAnimation: TextAnimationSettingsPage(),
    SettingsNavigationPageNames.voiceAssistant: VoiceAssistantSettingsPage(),
    SettingsNavigationPageNames.answerSound: AnswerSoundSettingsPage(),
  };
}
