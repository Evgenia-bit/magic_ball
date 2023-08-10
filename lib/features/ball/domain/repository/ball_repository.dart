import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = 'https://eightballapi.com/api';

class BallRepository {
  final _pref = SharedPreferences.getInstance();
  final _sharingAnimationDurationKey = "sharingAnimationDuration";
  final _floatingAnimationDurationKey = "floatingAnimationDuration";
  final _sharingCurveKey = "sharingCurve";
  final _floatingCurveKey = "floatingCurve";
  final _voiceAssistantEnableKey = "voiceAssistantEnable";
  final _currentSoundKey = "currentSound";
  final _textTransitionKey = "textTransition";

  BallRepository();

  Future<int?> get sharingAnimationDuration async =>
      (await _pref).getInt(_sharingAnimationDurationKey);

  Future<int?> get floatingAnimationDuration async =>
      (await _pref).getInt(_floatingAnimationDurationKey);

  Future<String?> get sharingAnimationCurve async =>
      (await _pref).getString(_sharingCurveKey);

  Future<String?> get floatingAnimationCurve async =>
      (await _pref).getString(_floatingCurveKey);

  Future<bool?> get voiceAssistantEnable async =>
      (await _pref).getBool(_voiceAssistantEnableKey);

  Future<String?> get currentSoundTitle async =>
      (await _pref).getString(_currentSoundKey);

  Future<int?> get textTransition async =>
      (await _pref).getInt(_textTransitionKey);

  Future<void> saveShakingAnimationDurationToPrefs(int duration) async {
    (await _pref).setInt(_sharingAnimationDurationKey, duration);
  }

  Future<void> saveFloatingAnimationDurationToPrefs(int duration) async {
    (await _pref).setInt(_floatingAnimationDurationKey, duration);
  }

  Future<void> saveShakingCurveToPrefs(String curveTitle) async {
    (await _pref).setString(_sharingCurveKey, curveTitle);
  }

  Future<void> saveFloatingCurveToPrefs(String curveTitle) async {
    (await _pref).setString(_floatingCurveKey, curveTitle);
  }

  Future<void> saveVoiceAssistantEnableToPrefs(bool enable) async {
    (await _pref).setBool(_voiceAssistantEnableKey, enable);
  }

  Future<void> saveSoundToPrefs(String? soundTitle) async {
    (await _pref).setString(_currentSoundKey, soundTitle ?? '');
  }

  Future<void> saveTextTransitionToPrefs(int transitionIndex) async {
    (await _pref).setInt(_textTransitionKey, transitionIndex);
  }

  static var r = '';

  Future<String> getAnswer() async {
    final result = await get(Uri.parse(url));
    return jsonDecode(result.body)['reading'];
  }
}
