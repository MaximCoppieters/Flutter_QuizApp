import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Settings {
  SWITCHTHEME,
  TIMEMODE,
  SINGLECHOICEMODE,
  MULTIPLECHOICEMODE,
  SKIPINTRO
}

class SettingsModel extends Model {
  bool _lightThemeEnabled;
  bool _timeModeEnabled;
  bool _singleChoiceOnlyEnabled;
  bool _multiChoiceOnlyEnabled;
  bool _skipIntro;

  bool get lightThemeEnabled => _lightThemeEnabled;
  bool get timeModeEnabled => _timeModeEnabled;
  bool get singleChoiceOnlyEnabled => _singleChoiceOnlyEnabled;
  bool get multiChoiceOnlyEnabled => _multiChoiceOnlyEnabled;
  bool get skipIntro => _skipIntro;
  SharedPreferences userSettings;

  static final _instance = SettingsModel._internal();

  factory SettingsModel() {
    return _instance;
  }

  SettingsModel._internal() {
    _lightThemeEnabled = true;
    _setSavedSettings();
  }

  void _setSavedSettings() async {
    SharedPreferences.getInstance().then((settings) {
      userSettings = settings;
      _skipIntro = userSettings.getBool("skipIntro") ?? false;
      _lightThemeEnabled = userSettings.getBool("lightTheme") ?? false;
      _singleChoiceOnlyEnabled = userSettings.getBool("singleChoiceMode") ?? false;
      _multiChoiceOnlyEnabled = userSettings.getBool("multiChoiceMode") ?? false;
      _timeModeEnabled = userSettings.getBool("timeMode") ?? false;
    });
  }

  set multiChoiceOnlyEnabled(bool value) {
    _multiChoiceOnlyEnabled = value;
    notifyListeners();
  }

  void toggleSkipIntro() {
    _skipIntro = !_skipIntro;
    userSettings.setBool("skipIntro", _skipIntro);
    notifyListeners();
  }

  void toggleTimeMode() {
    _timeModeEnabled = !_timeModeEnabled;
    userSettings.setBool("timeMode", _timeModeEnabled);
    notifyListeners();
  }
  void toggleSingleChoiceMode() {
    _singleChoiceOnlyEnabled = !_singleChoiceOnlyEnabled;
    if (_singleChoiceOnlyEnabled) {
      _multiChoiceOnlyEnabled = false;
      userSettings.setBool("multiChoiceMode", false);
    }
    userSettings.setBool("singleChoiceMode", _singleChoiceOnlyEnabled);
    notifyListeners();
  }
  void toggleMultipleChoiceMode() {
    _multiChoiceOnlyEnabled = !_multiChoiceOnlyEnabled;
    if (_multiChoiceOnlyEnabled) {
      _singleChoiceOnlyEnabled = false;
      userSettings.setBool("singleChoiceMode", false);
    }
    userSettings.setBool("multiChoiceMode", _multiChoiceOnlyEnabled);
    notifyListeners();
  }

  void switchThemes() {
    _lightThemeEnabled = !_lightThemeEnabled;
    userSettings.setBool("lightTheme", _lightThemeEnabled);
    notifyListeners();
  }

  bool getValue(Settings setting) {
    switch(setting) {
      case Settings.SWITCHTHEME:
        return _lightThemeEnabled;
      case Settings.MULTIPLECHOICEMODE:
        return _multiChoiceOnlyEnabled;
      case Settings.SINGLECHOICEMODE:
        return _singleChoiceOnlyEnabled;
      case Settings.TIMEMODE:
        return _timeModeEnabled;
      case Settings.SKIPINTRO:
        return _skipIntro;
    }
    throw("No settings enum found for that setting");
  }

  void toggleValue(Settings setting) {
    switch(setting) {
      case Settings.SWITCHTHEME:
        switchThemes();
        break;
      case Settings.MULTIPLECHOICEMODE:
        toggleMultipleChoiceMode();
        break;
      case Settings.SINGLECHOICEMODE:
        toggleSingleChoiceMode();
        break;
      case Settings.TIMEMODE:
        toggleTimeMode();
        break;
      case Settings.SKIPINTRO:
        toggleSkipIntro();
        break;
    }
  }
}
