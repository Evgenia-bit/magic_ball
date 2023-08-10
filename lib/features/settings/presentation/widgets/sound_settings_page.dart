import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/sound.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_view_model.dart';

class AnswerSoundSettingsPage extends StatelessWidget {
  const AnswerSoundSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (defaultSoundsList, customSoundsList) = context.select(
      (SettingsSheetViewModel model) => (model.state.defaultSoundsList, model.state.customSoundsList),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: context.read<SettingsSheetViewModel>().pickSound,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Загрузить свой'),
                Icon(Icons.add),
              ],
            )),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              const _SoundsListItem(),
              if (customSoundsList.isNotEmpty) ...[
                Text(
                  'Мои звуки',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
                ...customSoundsList
                    .map((sound) => _SoundsListItem(
                          sound: sound,
                          isDismissible: true,
                        ))
                    .toList(),
              ],
              Text(
                'Встроенные звуки',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              ...defaultSoundsList
                  .map((sound) => _SoundsListItem(sound: sound))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SoundsListItem extends StatelessWidget {
  final Sound? sound;
  final bool isDismissible;

  const _SoundsListItem({
    Key? key,
    this.sound,
    this.isDismissible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soundTitle = context.select((BallViewModel model) => model.state.sound?.title);
    final ballModel = context.read<BallViewModel>();
    final settingsModel = context.read<SettingsSheetViewModel>();

    Widget? trailing;
    if (soundTitle == sound?.title) {
      trailing = const Icon(Icons.check);
    }

    final child = ListTile(
      trailing: trailing,
      onTap: () => ballModel.updateSound(sound),
      title: Text(
        sound?.title ?? 'Нет',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );

    if (isDismissible) {
      return Dismissible(
        key: ValueKey(sound?.fileName),
        onDismissed: (direction) async {
          await ballModel.removeSound(sound);
          await settingsModel.updateCustomSoundsList();
        },
        background: const ColoredBox(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Icon(Icons.delete), SizedBox(width: 10)],
          ),
        ),
        child: child,
      );
    }
    return child;
  }
}
