import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/core/styles/colors.dart';
import 'package:surf_practice_magic_ball/core/styles/theme.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_container.dart';
import 'package:surf_practice_magic_ball/features/main/presentation/widgets/bottom_text.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.backgroundTopColor,
              theme.colorScheme.backgroundBottomColor,
            ],
          ),
        ),
        child:  const Stack(
          fit: StackFit.expand,
          children: [
            BallContainer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomText(),
            ),
            SettingsSheet(),
          ],
        ),
      ),
    );
  }
}
