import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';

class VoiceAssistantSettingsPage extends StatelessWidget {
  const VoiceAssistantSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceAssistantEnable = context.select(
      (BallViewModel model) => model.state.voiceAssistantEnable,
    );
    return SwitchListTile(
      title: Text(
        "Озвучивать ответ",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onChanged: context.read<BallViewModel>().changeVoiceAssistantEnable,
      value: voiceAssistantEnable,
    );
  }
}
