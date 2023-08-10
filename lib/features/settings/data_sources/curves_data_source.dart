import 'package:flutter/animation.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/custom_curve.dart';

final curvesDataSource = [
  CustomCurve(
    curve: Curves.linear,
    title: 'linear',
    imageFileName: 'linear.png',
  ),
  CustomCurve(
   curve: Curves.decelerate,
    title: 'decelerate',
    imageFileName: 'decelerate.png',
  ),
  CustomCurve(
    curve: Curves.slowMiddle,
    title: 'slowMiddle',
    imageFileName: 'slow_middle.png',
  ),
  CustomCurve(
    curve: Curves.ease,
    title: 'ease',
    imageFileName: 'ease.png',
  ),
  CustomCurve(
    curve: Curves.easeIn,
    title: 'easeIn',
    imageFileName: 'ease_in.png',
  ),
  CustomCurve(
    curve: Curves.bounceIn,
    title: 'bounceIn',
    imageFileName: 'bounce_in.png',
  ),
];
