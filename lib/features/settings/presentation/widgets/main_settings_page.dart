import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/settings_variety.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_view_model.dart';

class MainSettingsPage extends StatelessWidget {
  const MainSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsList =
        context.read<SettingsSheetViewModel>().state.settingsList;
    return Wrap(
      alignment: WrapAlignment.center,
      children: settingsList
          .map((setting) => _SettingsItem(setting: setting))
          .toList(),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final SettingVariety setting;

  const _SettingsItem({Key? key, required this.setting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.read<SettingsSheetViewModel>().goToSettingPage(setting, context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 100,
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Icon(setting.iconData),
            ),
            Expanded(
              child: Text(
                setting.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
