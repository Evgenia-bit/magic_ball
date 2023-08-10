import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/features/app/domain/repository/theme_repository.dart';

class ColorSettingsPage extends StatelessWidget {
  const ColorSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    return SwitchListTile(
      title: Text(
        "Тёмный режим",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onChanged: (value) {
        themeNotifier.toggleTheme();
      },
      value: themeNotifier.dark!,
    );
  }
}
