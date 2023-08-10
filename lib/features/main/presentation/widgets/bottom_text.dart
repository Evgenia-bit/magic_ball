import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/core/utils/adaptability_manager.dart';
import 'package:surf_practice_magic_ball/features/common/widgets/custom_animated_switched.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_view_model.dart';

//виджет текста внизу экрана
class BottomText extends StatelessWidget {
  const BottomText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sheetState = context.select(
      (SettingsSheetViewModel model) => model.state.sheetState,
    );
    final SizedBox child;

    if (sheetState == SheetState.open) {
      child = const SizedBox.shrink();
    } else {
      child = SizedBox(
        key: const ValueKey('bottom_text'),
        width: AdaptabilityManager.magicBallSize / 1.5,
        height: 100,
        child: Column(
          children: [
            Text(
              AdaptabilityManager.bottomText,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }
    return CustomAnimatedSwitched(
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }
}
