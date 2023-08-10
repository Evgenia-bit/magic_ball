import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/custom_curve.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_view_model.dart';

class BallAnimationSettingsPage extends StatelessWidget {
  const BallAnimationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<BallViewModel>();
    final (floatingDuration, floatingCurve, shakingDuration, shakingCurve) =
        context.select(
      (BallViewModel model) => (
        model.state.floatingAnimationMode.duration,
        model.state.floatingAnimationMode.curve,
        model.state.shakingAnimationMode.duration,
        model.state.shakingAnimationMode.curve,
      ),
    );

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              children: [
                _SettingsTabBarView(
                  animationDuration: floatingDuration,
                  animationCurve: floatingCurve,
                  setAnimationDuration: model.updateFloatingAnimationDuration,
                  setAnimationCurve: model.updateFloatingAnimationCurve,
                ),
                _SettingsTabBarView(
                  animationDuration: shakingDuration,
                  animationCurve: shakingCurve,
                  setAnimationDuration: model.updateShakingAnimationDuration,
                  setAnimationCurve: model.updateShakingAnimationCurve,
                ),
              ],
            ),
          ),
          const TabBar(
            tabs: [
              Tab(text: 'Состояние покоя'),
              Tab(text: 'Состояние тряски'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsTabBarView extends StatelessWidget {
  final Duration animationDuration;
  final Curve animationCurve;
  final void Function(int) setAnimationDuration;
  final void Function(CustomCurve) setAnimationCurve;

  const _SettingsTabBarView({
    Key? key,
    required this.animationDuration,
    required this.animationCurve,
    required this.setAnimationDuration,
    required this.setAnimationCurve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (curvesList, currentCurveTitle) = context.select(
      (SettingsSheetViewModel model) => (
        model.state.curvesList,
        model.state.currentCurveTitle,
      ),
    );
    final textTheme = Theme.of(context).textTheme;
    final animationDurationInMilliseconds = animationDuration.inMilliseconds;
    final isSelectedCurveList = context
        .read<SettingsSheetViewModel>()
        .getIsSelectedCurveList(animationCurve);

    return Column(
      children: [
        Text('Скорость', style: textTheme.bodyMedium),
        Slider(
          label: '$animationDurationInMilliseconds милисекунд',
          divisions: 29,
          min: 100,
          max: 3000,
          value: animationDurationInMilliseconds.toDouble(),
          onChanged: (double value) {
            setAnimationDuration(value.toInt());
          },
        ),
        Text('Кривая', style: textTheme.bodyMedium),
        Text(currentCurveTitle, style: textTheme.bodySmall),
        ToggleButtons(
          onPressed: (int index) {
            final curve =
                context.read<SettingsSheetViewModel>().getCurveByIndex(index);
            setAnimationCurve(curve);
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          constraints: const BoxConstraints(
            minHeight: 40.0,
            minWidth: 40.0,
          ),
          isSelected: isSelectedCurveList,
          children: curvesList
              .map((customCurve) => _CurveToggleButton(
                    fileName: customCurve.imageFileName,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _CurveToggleButton extends StatelessWidget {
  final String fileName;

  const _CurveToggleButton({Key? key, required this.fileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final path = 'assets/images/curves/$fileName';

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        theme.colorScheme.primary,
        BlendMode.srcATop,
      ),
      child: Image.asset(
        path,
        height: 30,
        width: 30,
      ),
    );
  }
}
