import 'package:flutter/material.dart';
import 'package:programming_quiz/Controller/navigation_helper.dart';
import 'package:programming_quiz/Model/progression.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/answer_animations.dart';
import 'package:programming_quiz/View/choice_widgets.dart';
import 'package:programming_quiz/View/activity_view.dart';
import 'package:programming_quiz/View/utility_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:programming_quiz/Model/courses.dart';

Questions _questions;

class QuizView extends StatefulWidget {
  QuizView([Questions questions]) {
    if (questions != null) _questions = questions;
  }

  @override
  State<StatefulWidget> createState() {
    return QuizViewState();
  }
}

class QuizViewState extends State<QuizView> {
  Question _currentQuestion;

  QuizViewState();

  @override
  void initState() {
    _currentQuestion = _questions.getNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _currentQuestion == null
        ? QuestionsAnsweredView()
        : WillPopScope(
            onWillPop: () {
              NavigationHelper.goToActivityPage(context);
            },
            child: ScopedModelDescendant<CourseModel>(
                builder: (context, child, courseModel) => Scaffold(
                    appBar: AppBar(
                      backgroundColor: courseModel.course.mainColor,
                      title: Text("${courseModel.course.toString()}"),
                      actions: <Widget>[
                        ScopedModelDescendant<SettingsModel>(
                          builder: (context, child, settings) =>
                              settings.timeModeEnabled
                                  ? TimerDisplayWidget(_currentQuestion)
                                  : Container(),
                        ),
                      ],
                    ),
                    body: ScopedModel<Question>(
                      model: _currentQuestion,
                      child: Container(
                        margin: EdgeInsets.only(top: 2.0),
                        width: double.infinity,
                        child: ScopedModelDescendant<SettingsModel>(
                          builder: (context, child, settings) => Card(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  TextTitle(
                                      text:
                                          "Question ${_questions.questionNumber}"),
                                  LeftAlignedTitle(
                                      _currentQuestion.problemPrefix),
                                  _currentQuestion.problem
                                          .toString()
                                          .contains("/")
                                      ? Image(
                                          image: AssetImage(
                                              _currentQuestion.problem),
                                        )
                                      : LeftAlignedTitle(
                                          _currentQuestion.problem),
                                  LeftAlignedTitle(
                                      _currentQuestion.questionPhrase),
                                  AnswerChoices(
                                      _currentQuestion.choices.length),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.all(15.0),
                                              child: CheckAnswerButton(
                                                  courseModel))),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 70.0, right: 15.0),
                                              child: NextButton(courseModel))),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ))),
          );
  }
}

class QuestionsAnsweredView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Congratulations, you completed every question!",
              style: TextStyle(color: Colors.deepOrange, fontSize: 30.0),
              textAlign: TextAlign.center,
            ),
            Icon(Icons.tag_faces, color: Colors.deepOrange, size: 100.0),
            VerticalSpacer(26.0),
            LargeButton(
              text: "Go back",
              buttonColor: Colors.pink,
              accentColor: Colors.pinkAccent,
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ActivityPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final CourseModel _courseModel;

  NextButton(this._courseModel);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Question>(
      builder: (context, child, question) => _questionAnsweredAlready(question)
          ? RaisedButton(
              onPressed: () {
                NavigationHelper.goToQuizPage(context, _courseModel.course);
              },
              color: Colors.green,
              child: Row(
                children: <Widget>[
                  TextTitle(text: "Next"),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
            )
          : Container(),
    );
  }
}

class CheckAnswerButton extends StatelessWidget {
  final CourseModel _courseModel;
  CheckAnswerButton(this._courseModel);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProgressionModel>(
        builder: (context, child, progression) =>
            (ScopedModelDescendant<SettingsModel>(
              builder: (context, child, settings) =>
                  ScopedModelDescendant<Question>(
                      builder: (context, child, question) =>
                          !_questionAnsweredAlready(question)
                              ? RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 15.0),
                                  child: TextTitle(text: "Check Answer"),
                                  color: Colors.teal,
                                  onPressed: () {
                                    Questions.evaluateAnswerAndUpdateProgression(question, progression, _courseModel, settings);
                                    NavigationHelper.showAnswerAnimation(
                                        context, question);
                                  },
                                )
                              : Container()),
            )));
  }
}

bool _questionAnsweredAlready(Question question) {
  return question.questionAnsweredCorrectly != null;
}

class AnswerChoices extends StatefulWidget {
  final int _choiceCount;
  AnswerChoices(this._choiceCount);

  @override
  State<StatefulWidget> createState() {
    return AnswerChoiceState(_choiceCount);
  }
}

class AnswerChoiceState extends State<AnswerChoices> {
  int _choiceCount;
  AnswerChoiceState(this._choiceCount);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 6.0),
        child: Column(
          children: _generateChoiceList(_choiceCount),
        ));
  }
}

List<StatefulWidget> _generateChoiceList(int _choiceCount) {
  List<StatefulWidget> _choiceList = [];

  for (int i = 0; i < _choiceCount; i++) {
    _choiceList.add(ChoiceWidget(i));
  }

  return _choiceList;
}
