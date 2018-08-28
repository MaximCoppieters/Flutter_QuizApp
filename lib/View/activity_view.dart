import 'package:flutter/material.dart';
import 'package:programming_quiz/Controller/navigation_helper.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/utility_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ActivityPageState();
  }
}

class ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        NavigationHelper.goToHomePage(context);
      },
      child: Scaffold(
        body: ScopedModelDescendant<SettingsModel>(
          builder: (context, child, settings) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _generateScreenTilesFromCourses(context, settings),
              ),
        ),
      ),
    );
  }
}

List<ScreenTileButton> _generateScreenTilesFromCourses(BuildContext context, SettingsModel settings) {
  return Course.values
      .map((course) => ScreenTileButton(
          course: course,
          settings: settings,
          numberOfTiles: Course.values.length))
      .toList();
}
