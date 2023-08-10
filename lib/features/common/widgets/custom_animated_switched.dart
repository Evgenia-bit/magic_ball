import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_view_model.dart';

class CustomAnimatedSwitched extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final TextTransition transition;

  const CustomAnimatedSwitched({
    Key? key,
    required this.child,
    this.duration = fadeSwitchAnimationDuration,
    this.transition = TextTransition.fade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: transition.transitionBuilder,
      child: child,
    );
  }
}
