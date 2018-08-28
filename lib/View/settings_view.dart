import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/utility_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerTitle(
            text: "Visual",
          ),
          DrawerSetting(
            name: "Dark Theme",
            settings: Settings.SWITCHTHEME,
          ),
          DrawerTitle(
            text: "Quiz",
          ),
          DrawerSetting(
            name: "Time mode",
            settings: Settings.TIMEMODE,
          ),
          DrawerSetting(
            name: "Only Single-Choice",
            settings: Settings.SINGLECHOICEMODE,
          ),
          DrawerSetting(
            name: "Only Multi-Choice",
            settings: Settings.MULTIPLECHOICEMODE,
          ),
          DrawerTitle(
            text: "Menu",
          ),
          DrawerSetting(
            name: "Skip Welcome Screen",
            settings: Settings.SKIPINTRO,
          ),
        ],
      ),
    );
  }
}
