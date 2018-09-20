import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
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

  SharedPreferences _userSettings;
  String get nickname => _userSettings.getString("nickname");

  set nickname(nickname) => nickname ?? _userSettings.setString("nickname", nickname);

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
      _userSettings = settings;
      _skipIntro = _userSettings.getBool("skipIntro") ?? false;
      _lightThemeEnabled = _userSettings.getBool("lightTheme") ?? false;
      _singleChoiceOnlyEnabled = _userSettings.getBool("singleChoiceMode") ?? false;
      _multiChoiceOnlyEnabled = _userSettings.getBool("multiChoiceMode") ?? false;
      _timeModeEnabled = _userSettings.getBool("timeMode") ?? false;
    });
  }

  set multiChoiceOnlyEnabled(bool value) {
    _multiChoiceOnlyEnabled = value;
    _userSettings.setBool("multiChoiceMode", _multiChoiceOnlyEnabled);
    notifyListeners();
  }

  void toggleSkipIntro() {
    _skipIntro = !_skipIntro;
    _userSettings.setBool("skipIntro", _skipIntro);
    notifyListeners();
  }

  void toggleTimeMode() {
    _timeModeEnabled = !_timeModeEnabled;
    _userSettings.setBool("timeMode", _timeModeEnabled);
    notifyListeners();
  }
  void toggleSingleChoiceMode() {
    _singleChoiceOnlyEnabled = !_singleChoiceOnlyEnabled;
    if (_singleChoiceOnlyEnabled) {
      _multiChoiceOnlyEnabled = false;
      _userSettings.setBool("multiChoiceMode", false);
    }
    _userSettings.setBool("singleChoiceMode", _singleChoiceOnlyEnabled);
    notifyListeners();
  }
  void toggleMultipleChoiceMode() {
    _multiChoiceOnlyEnabled = !_multiChoiceOnlyEnabled;
    if (_multiChoiceOnlyEnabled) {
      _singleChoiceOnlyEnabled = false;
      _userSettings.setBool("singleChoiceMode", false);
    }
    _userSettings.setBool("multiChoiceMode", _multiChoiceOnlyEnabled);
    notifyListeners();
  }

  void switchThemes(BuildContext context) {
    _lightThemeEnabled = !_lightThemeEnabled;
    DynamicTheme.of(context).setThemeData(!_lightThemeEnabled ? ThemeData.light() : ThemeData.dark());
    _userSettings.setBool("lightTheme", _lightThemeEnabled);
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

  void toggleValue(Settings setting, BuildContext build) {
    switch(setting) {
      case Settings.SWITCHTHEME:
        switchThemes(build);
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
