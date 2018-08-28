import 'dart:math';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:programming_quiz/Controller/navigation_helper.dart';
import 'package:programming_quiz/View/activity_view.dart';
import 'package:programming_quiz/View/progress_view.dart';
import 'package:programming_quiz/View/settings_view.dart';
import 'package:programming_quiz/View/utility_widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsDrawer(),
      body: Stack(
          children: _generateRandomWidgets(10, context)
            ..add(
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Builder(
                    builder: (BuildContext context) => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            LargeButton(
                              onPress: () {
                                NavigationHelper.goToActivityPage(context);
                              },
                              text: "Practice",
                              buttonColor: Colors.pink,
                              accentColor: Colors.pinkAccent,
                            ),
                            LargeButton(
                                onPress: () {},
                                text: "Leaderboard",
                                buttonColor: Colors.orange,
                                accentColor: Colors.orangeAccent),
                            LargeButton(
                              onPress: () {
                                NavigationHelper.goToProgressPage(context);
                              },
                              text: "Progress",
                              buttonColor: Colors.teal,
                              accentColor: Colors.tealAccent,
                            ),
                            LargeButton(
                              onPress: () {
                                Scaffold.of(context).openDrawer();
                              },
                              text: "Settings",
                              buttonColor: Colors.brown,
                              accentColor: Colors.black26,
                            )
                          ],
                        ),
                  ),
                ),
              ),
            )),
    );
  }
}

List<Widget> _generateRandomWidgets(int amount, BuildContext context) {
  List<Rectangle> widgetSpaces = [];
  List<Widget> randomWidgets = [];

  for (int i = 0; i < amount; i++) {
    RandomTransformedPositionedIcon randomIcon;
    Rectangle currentSpace;
    do {
      randomIcon = RandomTransformedPositionedIcon(context);
      currentSpace = Rectangle(randomIcon.xRandom, randomIcon.yRandom,
          randomIcon.size, randomIcon.size);
    } while (_overlapsOtherIcons(currentSpace, widgetSpaces));
    widgetSpaces.add(currentSpace);
    randomWidgets.add(randomIcon);
  }
  return randomWidgets;
}

bool _overlapsOtherIcons(Rectangle iconSpace, List<Rectangle> takenSpaces) {
  return takenSpaces.any((space) => space?.intersects(iconSpace) ?? false);
}

class RandomTransformedPositionedIcon extends StatelessWidget {
  static Random _rng = Random();
  static List<IconData> _possibleIconData = [
    Icons.access_alarms,
    Icons.directions_bike,
    Icons.tag_faces,
    Icons.create,
    Icons.description,
    Icons.rss_feed,
    Icons.thumb_up,
    Icons.computer,
    Icons.phone_iphone,
    Icons.search,
    Icons.add,
    Icons.euro_symbol,
    Icons.local_airport,
    Icons.radio,
    Icons.phone,
    Icons.assignment_turned_in
  ];
  Icon _icon;
  double _angle;
  int _xRandom;
  int _yRandom;
  double _size;

  int get xRandom => _xRandom;
  int get yRandom => _yRandom;
  double get size => _size;
  double get angle => _angle;

  RandomTransformedPositionedIcon(BuildContext context) {
    _size = (_rng.nextInt(80) + 60).floorToDouble();
    _icon = _generateIcon();
    _angle = _rng.nextDouble();

    var maxWidth = MediaQuery.of(context).size.width;
    var maxHeight = MediaQuery.of(context).size.height;

    _xRandom = _rng.nextInt(maxWidth.floor());
    _yRandom = _rng.nextInt(maxHeight.floor());
  }

  Icon _generateIcon() {
    _possibleIconData.shuffle();
    var randomIndex = _rng.nextInt(_possibleIconData.length);
    var randomIconData = _possibleIconData[randomIndex];
    var greyscale = (_rng.nextInt(3) + 3) * 100;
    return Icon(
      randomIconData,
      size: _size,
      color: Colors.grey[greyscale],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _xRandom.truncateToDouble(),
      bottom: _yRandom.truncateToDouble(),
      child: Transform.rotate(
        child: _icon,
        angle: _angle,
      ),
    );
  }
}
