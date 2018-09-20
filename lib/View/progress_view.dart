import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:programming_quiz/Controller/firestore_helper.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/utility_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class ProgressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProgressPageState();
  }
}

class ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Progression"),
      ),
      body: ScopedModelDescendant<SettingsModel>(
        builder: (context, child, settingsModel) => StreamBuilder(
          stream: FirestoreHelper.getPlayerSnapshots(settingsModel.nickname),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                children:
                    _generateProgressionContainers(snapshot.data.documents[0]),
              );
            } else {
              return Text("waiting");
            }
          },
        ),
      ),
    );
  }
}

List<Widget> _generateProgressionContainers(DocumentSnapshot snapshot) {
  List courseNamesData = snapshot.data["courses"];

  return courseNamesData
      .map((courseData) => ProgressionContainer(courseData))
      .toList();
}

class ProgressionContainer extends StatelessWidget {
  final Map courseData;
  final Course course;

  ProgressionContainer(this.courseData)
      : course = Course.getCourseByFormalName(courseData["name"]);

  @override
  Widget build(BuildContext context) {
    int amountUnanswered =
        courseData["count"] - courseData["correct"] - courseData["wrong"];

    return Container(
      padding: EdgeInsets.only(top: 3.0, bottom: 8.0),
      child: Column(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0)),
              color: course.mainColor,
              border: Border.all(
                  width: 2.0, style: BorderStyle.solid, color: course.mainColor)),
          width: double.infinity,
          child: TextTitle(
              text: "${courseData["name"]}",
              color: Colors.white,
              fontSize: 26.0,
              textAlign: TextAlign.center),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(20.0)),
              border: Border.all(
                  width: 2.0, style: BorderStyle.solid, color: course.mainColor)),
          child: courseData["count"] == 0
              ? Center(
                  heightFactor: 3.0, child: TextTitle(text: "No Progression"))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextTitle(
                          text: "Correct",
                          textAlign: TextAlign.center,
                        ),
                        TextTitle(
                          text:
                              "${courseData["correct"]}/${courseData["count"]}",
                          textAlign: TextAlign.center,
                        ),
                        Icon(Icons.check, color: Colors.green, size: 40.0),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextTitle(
                          text: "Incorrect",
                          textAlign: TextAlign.center,
                        ),
                        TextTitle(
                          text: "${courseData["wrong"]}/${courseData["count"]}",
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextTitle(
                          text: "Unanswered",
                          textAlign: TextAlign.center,
                        ),
                        TextTitle(
                          text: "$amountUnanswered/${courseData["count"]}",
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.help,
                          color: Colors.blue,
                          size: 40.0,
                        ),
                      ],
                    )
                  ],
                ),
        ),
      ]),
    );
  }
}
