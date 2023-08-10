import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';

import '../settings_sheet_view_model.dart';

class TextAnimationSettingsPage extends StatelessWidget {
  const TextAnimationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ballModel = context.read<BallViewModel>();
    final title = context.select(
      (BallViewModel model) => model.state.textTransition.title,
    );
    final isSelectedTransitionList = ballModel.getIsSelectedTransitionList();
    const transitionList = TextTransition.values;

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 5),
        ToggleButtons(
          onPressed: (int index) {
            ballModel.changeTextTransition(transitionList[index]);
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          constraints: const BoxConstraints(
            minHeight: 50.0,
            minWidth: 50.0,
          ),
          isSelected: isSelectedTransitionList,
          children: transitionList
              .map(
                (transition) => _ToggleButton(transition: transition),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final TextTransition transition;

  const _ToggleButton({
    Key? key,
    required this.transition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(transition.iconData);
  }
}
