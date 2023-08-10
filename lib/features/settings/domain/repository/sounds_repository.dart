import 'dart:io';

import 'package:surf_practice_magic_ball/features/settings/data_sources/custom_sounds_data_source.dart';
import 'package:surf_practice_magic_ball/features/settings/data_sources/default_sounds_data_source.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/sound.dart';

class SoundsRepository {
  final _customSoundsDataSource = CustomSoundsDataSource();
  final _defaultSoundsDataSource = defaultSoundsDataSource;

  Future<List<Sound>> _getAllSounds() async {
    List<Sound> customSounds = await getCustomSounds();
    List<Sound> defaultSounds =  getDefaultSounds();
    return [...customSounds, ...defaultSounds];
  }

  Future<List<Sound>> getCustomSounds() async {
    return await _customSoundsDataSource.getSounds();
  }

  List<Sound> getDefaultSounds()  {
    return _defaultSoundsDataSource;
  }

  Future<void> uploadCustomSound(File file) async {
    await _customSoundsDataSource.uploadSound(file);
  }

 Future<void> removeCustomSound(Sound sound) async {
    await _customSoundsDataSource.removeSound(sound);
  }


 Future<Sound?> getSoundByTitle(String title) async {
    final sounds = await _getAllSounds();
    final soundList = sounds.where((sound) => sound.title == title);
    if(soundList.isEmpty) return null;
    return soundList.first;
  }
}
