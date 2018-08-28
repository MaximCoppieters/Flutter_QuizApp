import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:programming_quiz/View/home_view.dart';
import 'package:programming_quiz/View/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage> {
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  String nickname;
  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await Future.delayed(Duration(seconds: 4)).then((_) async {
        var userData = await SharedPreferences.getInstance();
        nickname = userData.getString("nickname");
      }),
      renderLoad: () => IntroScreen(),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading the main page'),
      renderSuccess: ({data}) => nickname == null ? LoginPage() : HomePage(),
    );
    return _asyncLoader;
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SchoolAnimation(),
              Text(
                "PXL",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 140.0,
                    height: 0.7),
              ),
              Image.asset("images/kahit_logo.png", height: 140.0),
              Text(
                "Programming Quiz",
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

class SchoolAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SchoolAnimationState();
  }
}

class SchoolAnimationState extends State<SchoolAnimation>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    _animation = Tween(begin: 100.0, end: 150.0).animate(_animationController);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SchoolLogoAnimation(
      animation: _animation,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SchoolLogoAnimation extends AnimatedWidget {
  SchoolLogoAnimation({Key key, Animation animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Container(
        height: 150.0,
        child: Icon(
          Icons.school,
          size: animation.value,
        ));
  }
}
