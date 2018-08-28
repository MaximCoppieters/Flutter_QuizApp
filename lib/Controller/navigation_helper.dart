import 'dart:async';

import 'package:flutter/material.dart';
import 'package:programming_quiz/Controller/question_reader.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/progression.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/activity_view.dart';
import 'package:programming_quiz/View/answer_animations.dart';
import 'package:programming_quiz/View/progress_view.dart';
import 'package:programming_quiz/View/quiz_view.dart';
import 'package:scoped_model/scoped_model.dart';

class NavigationHelper {
  static void openQuizWithQuestionsFromFile(Course course, BuildContext context,
      SettingsModel settings, ProgressionModel progression) async {
    QuestionReader questionReader = QuestionReader(settings);
    await questionReader.readQuestionsFromFile(course.csvPath);
    Questions _questions = questionReader.questions;

    String nickname = settings.userSettings.getString("nickname");
    await progression.getPlayerInfo(nickname);
    progression.setQuestionCount(_questions.count, course);

    NavigationHelper._goToQuizPage(context, course, _questions);
  }

  static void _goToQuizPage(
      BuildContext context, Course course, Questions questions) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScopedModel<CourseModel>(
                model: CourseModel(course), child: QuizView(questions))));
  }

  static void showAnswerAnimation(BuildContext context, Question question) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AnswerAnimation(question)));
  }

  static void goToHomePage(BuildContext context) {
    Navigator.of(context).pushNamed("/home");
  }

  static void goToActivityPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ActivityPage()));
  }

  static void goToProgressPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProgressPage()));
  }
}