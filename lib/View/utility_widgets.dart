import 'dart:async';

import 'package:flutter/material.dart';
import 'package:programming_quiz/Controller/navigation_helper.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/progression.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/answer_animations.dart';
import 'package:scoped_model/scoped_model.dart';

class WidgetUtils {
  static const largeButtonPadding =
      EdgeInsets.symmetric(horizontal: 28.0, vertical: 18.0);
  static final largeButtonShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
}

class VerticalSpacer extends StatelessWidget {
  final double _height;

  VerticalSpacer([this._height = 16.0]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
    );
  }
}

class DrawerTitle extends StatelessWidget {
  final String text;

  DrawerTitle({this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    );
  }
}

class DrawerSetting extends StatefulWidget {
  final String name;
  final Settings settings;
  DrawerSetting({@required this.name, @required this.settings});
  @override
  State<StatefulWidget> createState() {
    return DrawerSettingState(name, settings);
  }
}

class DrawerSettingState extends State<DrawerSetting> {
  final String name;
  final Settings setting;
  DrawerSettingState(this.name, this.setting);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SettingsModel>(
      builder: (context, child, settingsModel) => ListTile(
            leading: TextTitle(text: name),
            trailing: Switch(
              activeColor: Colors.green,
              value: settingsModel.getValue(setting),
              onChanged: (bool) {
                settingsModel.toggleValue(setting);
              },
            ),
          ),
    );
  }
}

class TimerDisplayWidget extends StatefulWidget {
  final Question _question;
  TimerDisplayWidget(this._question);

  @override
  State<StatefulWidget> createState() {
    return TimerDisplayWidgetState(_question);
  }
}

class TimerDisplayWidgetState extends State<TimerDisplayWidget> {
  Question _question;
  TimerDisplayWidgetState(this._question);
  Timer _secondsTimer;

  @override
  void initState() {
    super.initState();
    _question.setTimer();
    setSecondsTimer();
  }

  void updateState() {
    setState(() {
      if (_question.questionAnsweredCorrectly ?? true) {
        _question.decrementTimeRemaining();
        setSecondsTimer();
      } else {
        if (!_question.questionAnsweredCorrectly ?? false) {
          NavigationHelper.showAnswerAnimation(context, _question);
        }
      }
    });
  }

  void setSecondsTimer() {
    _secondsTimer = Timer(Duration(seconds: 1), updateState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      margin: EdgeInsets.only(right: 20.0, top: 3.0, bottom: 3.0),
      child: Center(child: TextTitle(text: "${_question.timeRemaining}")),
      foregroundDecoration: ShapeDecoration(
          shape:
              CircleBorder(side: BorderSide(width: 5.0, color: Colors.white))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _secondsTimer?.cancel();
  }
}

class LargeButton extends StatelessWidget {
  final String text;
  final MaterialColor buttonColor;
  final Color accentColor;
  final Function onPress;

  LargeButton(
      {@required this.text,
      @required this.onPress,
      this.buttonColor = Colors.blue,
      this.accentColor = Colors.blueAccent});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPress,
      elevation: 5.0,
      shape: WidgetUtils.largeButtonShape,
      padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
      child: Container(
        width: 240.0,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.title.fontSize),
        ),
      ),
      color: buttonColor,
      splashColor: accentColor,
      highlightColor: buttonColor[900],
    );
  }
}

class ScreenTileButton extends StatefulWidget {
  final int numberOfTiles;
  final Course course;
  final SettingsModel settings;

  ScreenTileButton(
      {@required this.course,
      @required this.numberOfTiles,
      @required this.settings});

  @override
  State<StatefulWidget> createState() {
    return ScreenTileButtonState(numberOfTiles, course, settings);
  }
}

class ScreenTileButtonState extends State<ScreenTileButton> {
  final int numberOfTiles;
  final Course course;
  final SettingsModel settings;
  bool isLoadingQuestions = false;

  ScreenTileButtonState(this.numberOfTiles, this.course, this.settings);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / numberOfTiles,
        child: ScopedModelDescendant<ProgressionModel>(
          builder: (context, child, progression) => RaisedButton(
            splashColor: course.accentColor,
            color: course.mainColor[400],
            shape: BeveledRectangleBorder(),
            onPressed: () {
              setState(() {
                isLoadingQuestions = true;
              });
              NavigationHelper.openQuizWithQuestionsFromFile(
                  course, context, settings, progression);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  course.toString(),
                  style: TextStyle(fontSize: 34.0, color: Colors.white),
                ),
                Container(
                  child: Image.asset(course.imagePath,
                      color: Colors.white, width: 100.0, height: 100.0),
                ),
                isLoadingQuestions ? LinearProgressIndicator() : Container(height: 4.0,),
              ],
            ),
          ),
        ));
  }
}

class TextTitle extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double fontSize;
  final Color color;

  TextTitle({this.text, this.textAlign, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize ?? 20.0,
          color: color ?? Theme.of(context).textTheme.title.color),
      textAlign: textAlign,
    );
  }
}

class LeftAlignedTitle extends StatelessWidget {
  final String text;
  LeftAlignedTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment(-1.0, 0.0),
          child: TextTitle(text: text),
        ));
  }
}
