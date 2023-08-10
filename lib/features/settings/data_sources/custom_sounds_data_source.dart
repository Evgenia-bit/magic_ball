import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/sound.dart';
import 'package:path/path.dart';

const soundsDirectoryName = 'sounds';

class CustomSoundsDataSource {
  Future<List<Sound>> getSounds() async {
    final dir = await _getSoundsDirPath();

    return dir.list().map((file) {
      final fileName = basename(file.path);
      return Sound.fromFile(fileName);
    }).toList();
  }

  Future<void> uploadSound(File file) async {
    final dir = await _getSoundsDirPath();
    await file.copy('${dir.path}/${basename(file.path)}');
  }

  Future<void> removeSound(Sound sound) async {
    final dir = await _getSoundsDirPath();
    dir.list().forEach((file) {
      if (basename(file.path) == sound.fileName) {
        file.deleteSync();
      }
    });
  }

  Future<Directory> _getSoundsDirPath() async {
    final dir = await _getLocalDirectory(soundsDirectoryName);
    await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> _getLocalDirectory(String dirName) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    return Directory('$path/$dirName');
  }
}
