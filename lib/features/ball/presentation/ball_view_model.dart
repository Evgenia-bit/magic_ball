import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shake/shake.dart';
import 'package:surf_practice_magic_ball/features/ball/domain/repository/ball_repository.dart';
import 'package:surf_practice_magic_ball/features/settings/data_sources/custom_sounds_data_source.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/custom_curve.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/sound.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/repository/curves_repository.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/repository/sounds_repository.dart';
import 'package:surf_practice_magic_ball/features/settings/presentation/settings_sheet_view_model.dart';

const fadeSwitchAnimationDuration = Duration(milliseconds: 1500);

enum BallState {
  start,
  loading,
  answerReceived,
  failed;

  String get ballImageFileName =>
      switch (this) { BallState.failed => 'failed.png', _ => 'ball.png' };

  String get bottomEllipseImageFileName => switch (this) {
        BallState.failed => 'failed_bottom_ellipse.png',
        _ => 'bottom_ellipse.png'
      };

  String get bottomShadowImageFileName => switch (this) {
        BallState.failed => 'failed_bottom_shadow.png',
        _ => 'bottom_shadow.png'
      };
}

sealed class AnimationBallMode {
  abstract Offset tweenEnd;

  abstract Duration duration;

  abstract Curve curve;
}

class FloatingAnimation extends AnimationBallMode {
  @override
  Offset tweenEnd = const Offset(0, .05);

  @override
  Duration duration = const Duration(milliseconds: 1000);

  @override
  Curve curve = Curves.linear;
}

class ShakingAnimation extends AnimationBallMode {
  @override
  Offset tweenEnd = const Offset(.03, 0);

  @override
  Duration duration = const Duration(milliseconds: 100);

  @override
  Curve curve = Curves.linear;
}

class BallViewModelState {
  BallState ballState = BallState.start;
  String answer = '';
  bool voiceAssistantEnable = true;
  Sound? sound;
  TextTransition textTransition = TextTransition.fade;

  Future<Source?> get soundSource async {
    if (sound == null) {
      return null;
    } else if (sound!.isCustom) {
      final dir = await getApplicationDocumentsDirectory();
      return DeviceFileSource(
          '${dir.path}/$soundsDirectoryName/${sound!.fileName}');
    } else {
      return AssetSource('sounds/${sound!.fileName}');
    }
  }

  final shakingAnimationMode = ShakingAnimation();
  final floatingAnimationMode = FloatingAnimation();

  Tween<Offset> get offsetTween => Tween<Offset>(
        begin: Offset.zero,
        end: currentAnimationMode.tweenEnd,
      );

  CurveTween get curveTween => CurveTween(
        curve: currentAnimationMode.curve,
      );

  AnimationBallMode get currentAnimationMode {
    return ballState == BallState.loading
        ? shakingAnimationMode
        : floatingAnimationMode;
  }
}

class BallViewModel extends ChangeNotifier {
  final _state = BallViewModelState();

  BallViewModelState get state => _state;
  final _ballRepository = BallRepository();
  final _animationCurveRepository = AnimationCurveRepository();
  final _soundsRepository = SoundsRepository();
  final _flutterTts = FlutterTts();
  final _player = AudioPlayer();
  AnimationController? _animationController;

  AnimationController? get animationController => _animationController;

  Animation<Offset>? get offsetAnimation =>
      _animationController?.drive(_state.curveTween).drive(_state.offsetTween);

  BallViewModel() {
    _loadFromPrefs();
    _flutterTts.setLanguage("en-US");
    _listenPlayer();
  }

  void _loadFromPrefs() {
    _loadFloatingAnimationDurationFromPrefs();
    _loadShakingAnimationDurationFromPrefs();
    _loadFloatingCurveAnimationFromPrefs();
    _loadShakingCurveAnimationFromPrefs();
    _loadVoiceAssistantEnableFromPrefs();
    _loadSoundFromPrefs();
    _loadTextTransitionFromPrefs();
  }

  Future<void> _loadFloatingAnimationDurationFromPrefs() async {
    final duration = await _ballRepository.floatingAnimationDuration;
    _updateAnimationModeDuration(duration, _state.floatingAnimationMode);
  }

  Future<void> _loadShakingAnimationDurationFromPrefs() async {
    final duration = await _ballRepository.sharingAnimationDuration;
    _updateAnimationModeDuration(duration, _state.shakingAnimationMode);
  }

  Future<void> _loadFloatingCurveAnimationFromPrefs() async {
    final curveTitle = await _ballRepository.floatingAnimationCurve;
    _updateAnimationModeCurve(curveTitle, _state.floatingAnimationMode);
  }

  Future<void> _loadShakingCurveAnimationFromPrefs() async {
    final curveTitle = await _ballRepository.sharingAnimationCurve;
    _updateAnimationModeCurve(curveTitle, _state.shakingAnimationMode);
  }

  void _updateAnimationModeCurve(
    String? curveTitle,
    AnimationBallMode animationMode,
  ) {
    if (curveTitle == null) return;
    final curve = _animationCurveRepository.getCurveByTitle(curveTitle)?.curve;
    if (curve != null) {
      animationMode.curve = curve;
    }
  }

  Future<void> _loadVoiceAssistantEnableFromPrefs() async {
    final enable = await _ballRepository.voiceAssistantEnable;
    if (enable != null) {
      _state.voiceAssistantEnable = enable;
    }
  }

  Future<void> _loadSoundFromPrefs() async {
    final title = await _ballRepository.currentSoundTitle;
    if (title != null) {
      final s = await _soundsRepository.getSoundByTitle(title);
      _state.sound = title == '' ? null : s;
    }
  }

  Future<void> _loadTextTransitionFromPrefs() async {
    final textTransitionIndex = await _ballRepository.textTransition;
    if (textTransitionIndex != null) {
      _state.textTransition = TextTransition.values[textTransitionIndex];
    }
  }

  void changeTextTransition(TextTransition transition) {
    _state.textTransition = transition;
    notifyListeners();
    _ballRepository.saveTextTransitionToPrefs(transition.index);
  }

  List<bool> getIsSelectedTransitionList() {
    return TextTransition.values
        .map(
          (transition) => transition == _state.textTransition,
        )
        .toList();
  }

  Future<void> loadAnswer() async {
    if (_state.ballState == BallState.loading) return;
    BallState ballState = BallState.loading;

    await _setBallState(ballState);
    _state.answer = '';

    try {
      //задержка нужна для анимирования загрузки ответа
      await Future.delayed(const Duration(seconds: 3));
      _state.answer = await _ballRepository.getAnswer();

      ballState = BallState.answerReceived;
    } catch (e) {
      _state.answer = 'Произошла ошибка';
      ballState = BallState.failed;
    } finally {
      await _setBallState(ballState);

      if ((await _state.soundSource) != null) {
        _playSound();
      } else {
        _speakAnswer();
      }
    }
  }

  void _listenPlayer() {
    _player.onPlayerComplete.listen((event) {
      _speakAnswer();
    });
  }

  void _speakAnswer() {
    if (_state.ballState == BallState.answerReceived &&
        _state.voiceAssistantEnable) {
      _flutterTts.speak(_state.answer);
    }
  }

  void createAnimationController(AnimationController value) {
    _animationController = value;
    _updateAnimationDuration();
  }

  void startShakeDetector() {
    ShakeDetector.autoStart(
      onPhoneShake: () => loadAnswer(),
    );
  }

  void changeVoiceAssistantEnable(bool value) {
    _state.voiceAssistantEnable = value;
    notifyListeners();
    _ballRepository.saveVoiceAssistantEnableToPrefs(value);
  }

  Future<void> updateSound(Sound? sound) async {
    _state.sound = sound;
    _playSound();
    notifyListeners();
    await _ballRepository.saveSoundToPrefs(sound?.title);
  }

  Future<void> removeSound(Sound? sound) async {
    if (sound == null) return;

    await _soundsRepository.removeCustomSound(sound);
    if (sound.fileName == _state.sound?.fileName) {
      await updateSound(null);
    }
  }

  void _playSound() async {
    final source = await _state.soundSource;
    if (source != null) {
      _player.play(source);
    }
  }

  Future<void> _setBallState(BallState value) async {
    _state.ballState = value;
    await _animationController?.animateTo(0);
    _updateAnimationDuration();
    notifyListeners();
  }

  void updateFloatingAnimationDuration(int milliseconds) {
    _updateAnimationModeDuration(milliseconds, _state.floatingAnimationMode);
    _ballRepository.saveFloatingAnimationDurationToPrefs(milliseconds.toInt());
  }

  void updateShakingAnimationDuration(int milliseconds) {
    _updateAnimationModeDuration(milliseconds, _state.shakingAnimationMode);
    _ballRepository.saveShakingAnimationDurationToPrefs(milliseconds.toInt());
  }

  void _updateAnimationModeDuration(
    int? milliseconds,
    AnimationBallMode animationMode,
  ) {
    if (milliseconds == null) return;
    animationMode.duration = Duration(milliseconds: milliseconds);
    notifyListeners();
    if (animationMode == _state.currentAnimationMode) {
      _updateAnimationDuration();
    }
  }

  void _updateAnimationDuration() {
    _animationController?.duration = _state.currentAnimationMode.duration;
    _animationController?.repeat(reverse: true);
  }

  void updateFloatingAnimationCurve(CustomCurve customCurve) {
    _state.floatingAnimationMode.curve = customCurve.curve;
    notifyListeners();
    _ballRepository.saveFloatingCurveToPrefs(customCurve.title);
  }

  void updateShakingAnimationCurve(CustomCurve customCurve) {
    _state.shakingAnimationMode.curve = customCurve.curve;
    notifyListeners();
    _ballRepository.saveShakingCurveToPrefs(customCurve.title);
  }
}
