import 'dart:async';

import 'package:flutter/material.dart';
import 'package:programming_quiz/Controller/firestore_helper.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/utility_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DynamicColor(),
          Center(
              child: Container(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      controller: _textController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                          filled: true,
                          fillColor: Colors.grey[300],
                          hintText: "Nickname",
                          hintStyle: TextStyle(
                            fontSize: 24.0,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            size: 36.0,
                            color: Colors.grey,
                          )),
                      style: TextStyle(color: Colors.black, fontSize: 24.0),
                    ),
                    VerticalSpacer(40.0),
                    ScopedModelDescendant<SettingsModel>(
                      builder: (context, child, settings) =>
                      LargeButton(
                        text: "Start Quizzing",
                        onPress: () {
                          _saveNickname(_textController.value.text, settings);
                          Navigator.pushNamed(context, "/home");
                        },
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

_saveNickname(String nickname, SettingsModel settings) async {
  settings.nickname = nickname;
  FirestoreHelper.createEmptyPlayerDocument(nickname);

  print("Added $nickname locally");
}

class DynamicColor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DynamicColorState();
  }
}

class DynamicColorState extends State<DynamicColor>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.yellow,
      Colors.pink,
      Colors.cyan,
      Colors.purple
    ];

    _controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);

    int startingColorIndex = 0;
    int endingColorIndex = 1;
    ColorTween colorTransition = ColorTween(
        begin: colors[startingColorIndex], end: colors[endingColorIndex]);

    _animation = colorTransition.animate(_controller);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        colorTransition.begin = _animation.value;
        endingColorIndex = (endingColorIndex + 1) % colors.length;
        colorTransition.end = colors[++endingColorIndex];
        _controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  int _rotateIndex(int index, int length) {
    return (++index % length);
  }

  @override
  Widget build(BuildContext context) {
    return ColorTransitionAnimation(
      animation: _animation,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class ColorTransitionAnimation extends AnimatedWidget {
  ColorTransitionAnimation({Key key, Animation animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Container(
      color: animation.value,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
  }
}
