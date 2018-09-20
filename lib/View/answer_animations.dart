import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/View/choice_widgets.dart';

class AnswerAnimation extends StatefulWidget {
  final Question _question;

  AnswerAnimation(this._question);

  @override
  State<StatefulWidget> createState() {
    return AnswerAnimationState(_question);
  }
}

class AnswerAnimationState extends State<AnswerAnimation>
    with SingleTickerProviderStateMixin {
  Question _question;
  AnswerAnimationState(this._question);

  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 50.0, end: 300.0).animate(animationController)
      ..addListener(() {
        setState(() {});
        if (animationController.isCompleted) {
          Navigator.pop(context);
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Stack(
      alignment: Alignment(0.0, 0.0),
      children: <Widget>[
        Align(
            alignment: Alignment(0.0, -0.5), child: getResponseText(_question)),
        Align(
            alignment: Alignment(0.0, 0.3),
            child: Container(
              height: animation.value,
              width: animation.value,
              child: _question.questionAnsweredCorrectly
                  ? CorrectLogo()
                  : IncorrectLogo(),
            )),
      ],
    )));
  }

  Text getResponseText(Question _question) {
    String response;
    if (_question.questionAnsweredCorrectly) {
      response = "CORRECT";
    } else {
      if (_question.timeRemaining == 0) {
        response = "TIME'S UP\n";
      } else {
        response = "INCORRECT\n";
      }
      if (_question is MultipleChoiceQuestion) {
        response += "The correct answers were ";
        List<int> correctAnswerIndices = _question.correctAnswerIndices;
        for (int index in correctAnswerIndices) {
          response += convertQuestionNumberToChar(index);
        }
      } else {
        if (_question is SingleChoiceQuestion) {
          response += "The correct answer was " +
              convertQuestionNumberToChar(_question.rightAnswerIndex);
        }
      }
    }
    return Text(
      response,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 34.0),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class CorrectLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: 500.0,
        height: 500.0,
        duration: Duration(milliseconds: 200),
        curve: ElasticOutCurve(),
        decoration: ShapeDecoration(
          image: DecorationImage(image: AssetImage("images/correct_icon.png")),
          shape:
              CircleBorder(side: BorderSide(width: 35.0, color: Colors.green)),
        ));
  }
}

class IncorrectLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: 500.0,
        height: 500.0,
        duration: Duration(milliseconds: 200),
        curve: ElasticInOutCurve(),
        decoration: ShapeDecoration(
          image: DecorationImage(image: AssetImage("images/wrong_icon.png")),
          shape: CircleBorder(side: BorderSide(width: 35.0, color: Colors.red)),
        ));
  }
}
