import 'package:flutter/material.dart';
import 'package:programming_quiz/Model/progression.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/activity_view.dart';
import 'package:programming_quiz/View/home_view.dart';
import 'package:programming_quiz/View/welcome_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<QuizApp> {
  SettingsModel _settingsModel;

  MyAppState() {
    _settingsModel = SettingsModel();
  }

  _getUserSettings() async {
    SharedPreferences settings = await SharedPreferences.getInstance();
    return settings.getBool("skipIntro");
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProgressionModel>(
      model: ProgressionModel(),
      child: ScopedModel<SettingsModel>(
        model: _settingsModel,
        child: DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => !_settingsModel.lightThemeEnabled
              ? ThemeData.light()
              : ThemeData.dark(),
          themedWidgetBuilder: (context, dynamicTheme) => MaterialApp(
                title: "Programming Questions",
                theme: dynamicTheme,
                home: FutureBuilder(
                  future: _getUserSettings(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return WelcomePage();
                    } else {
                      if (snapshot.data) {
                        return HomePage();
                      } else {
                        return WelcomePage();
                      }
                    }
                  },
                ),
                initialRoute: '/',
                routes: {
                  '/activity': (context) => ActivityPage(),
                  '/home': (context) => HomePage(),
                },
              ),
        ),
      ),
    );
  }
}
