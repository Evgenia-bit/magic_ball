import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/features/ball/presentation/ball_view_model.dart';
import 'package:surf_practice_magic_ball/features/settings/data_sources/curves_data_source.dart';
import 'package:surf_practice_magic_ball/features/settings/data_sources/settings_variety_data_source.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/custom_curve.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/settings_variety.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/sound.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/repository/sounds_repository.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_widget.dart';

const snapSheetDuration = Duration(milliseconds: 200);
const sheetMinChildSize = .05;
const sheetMaxChildSize = .3;
const sheetMiddleChildSize = (sheetMaxChildSize + sheetMinChildSize) / 2;

enum SheetState {
  open,
  close;

  IconData get headerButtonIconData => switch (this) {
        SheetState.open => Icons.close,
        SheetState.close => Icons.settings,
      };
}

enum TextTransition {
  fade,
  scale;

  Widget Function(Widget, Animation<double>) get transitionBuilder =>
      (Widget child, Animation<double> animation) {
        return switch (this) {
          TextTransition.fade =>
            FadeTransition(opacity: animation, child: child),
          TextTransition.scale => ScaleTransition(
              scale: animation,
              child: child,
            )
        };
      };

  IconData get iconData => switch (this) {
        TextTransition.fade => Icons.opacity,
        TextTransition.scale => Icons.scale,
      };

  String get title => switch (this) {
        TextTransition.fade => 'Прозрачность',
        TextTransition.scale => 'Размер',
      };
}

class SettingsSheetViewModelState {
  SheetState sheetState = SheetState.close;
  String headerTitle = '';
  bool isMainPage = true;
  List<Sound> defaultSoundsList = [];
  List<Sound> customSoundsList = [];
  List<SettingVariety> settingsList = settingsVarietyDataSource;
  List<CustomCurve> curvesList = curvesDataSource;
  String currentCurveTitle = '';
}

class SettingsSheetViewModel extends ChangeNotifier {
  final _soundsRepository = SoundsRepository();

  final _state = SettingsSheetViewModelState();

  SettingsSheetViewModelState get state => _state;

  final _controller = DraggableScrollableController();

  DraggableScrollableController get controller => _controller;

  SettingsSheetViewModel() {
    _updateSoundsList();
    _controller.addListener(() {
      processSnapSheet();
    });
  }

  Future<void> _updateSoundsList() async {
    _updateDefaultSoundsList();
    updateCustomSoundsList();
    notifyListeners();
  }

  void _updateDefaultSoundsList() {
    _state.defaultSoundsList =  _soundsRepository.getDefaultSounds();
  }

  Future<void> updateCustomSoundsList() async {
    _state.customSoundsList = await _soundsRepository.getCustomSounds();
    notifyListeners();
  }

  Future<void> pickSound() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result == null) return;

    File file = File(result.files.single.path!);
    await _soundsRepository.uploadCustomSound(file);
    await _updateSoundsList();
    notifyListeners();
  }

  CustomCurve getCurveByIndex(int index) {
    return _state.curvesList[index];
  }

 List<bool> getIsSelectedCurveList(Curve curve) {
    return _state.curvesList.map((customCurve) {
      final isSelected = customCurve.curve == curve;
      if (isSelected) {
        _state.currentCurveTitle = customCurve.title;
      }
      return isSelected;
    }).toList();
  }


  void goToMainPage() {
    final navContext = SettingsSheet.navKey.currentContext;
    if (navContext == null) return;
    Navigator.of(navContext).pop();
    _state.isMainPage = true;
    _state.headerTitle = 'Настройки';
    notifyListeners();
  }

  void goToSettingPage(SettingVariety setting, BuildContext context) {
    Navigator.of(context).pushNamed(setting.pageName);
    _state.headerTitle = setting.title;
    _state.isMainPage = false;
    notifyListeners();
  }

  void processSnapSheet() {
    if (!controller.isAttached) return;
    if (_state.sheetState == SheetState.open &&
        sheetMinChildSize <= controller.size &&
        controller.size <= sheetMiddleChildSize) {
      _closeSheet();
    } else if (_state.sheetState == SheetState.close &&
        sheetMiddleChildSize < controller.size &&
        controller.size <= sheetMaxChildSize) {
      _openSheet();
    }
  }

  void snapSheet() async {
    if (_state.sheetState == SheetState.close) {
      _controllerAnimateTo(sheetMaxChildSize);
      _openSheet();
    } else {
      await _controllerAnimateTo(sheetMinChildSize);
      _closeSheet();
    }
  }

  void _openSheet() {
    _state.sheetState = SheetState.open;
    _state.headerTitle = 'Настройки';
    notifyListeners();
    SettingsSheet.navKey.currentState?.pushReplacementNamed('/settings');
  }

  void _closeSheet() {
    _state.sheetState = SheetState.close;
    _state.headerTitle = '';
    _state.isMainPage = true;
    notifyListeners();
  }

  Future<void> _controllerAnimateTo(double size) async {
    await controller.animateTo(
      size,
      duration: snapSheetDuration,
      curve: Curves.linear,
    );
  }
}
