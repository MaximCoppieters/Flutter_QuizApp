import 'package:flutter/material.dart';
import 'package:programming_quiz/Controller/question_reader.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/progression.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:programming_quiz/View/activity_view.dart';
import 'package:programming_quiz/View/answer_animations.dart';
import 'package:programming_quiz/View/leaderboard_view.dart';
import 'package:programming_quiz/View/progress_view.dart';
import 'package:programming_quiz/View/quiz_view.dart';
import 'package:scoped_model/scoped_model.dart';

class NavigationHelper {
  static void openQuizWithQuestionsFromFile(Course course, BuildContext context,
      SettingsModel settings, ProgressionModel progression) async {

    String nickname = settings.nickname;
    await progression.getPlayerInfo(nickname);

    QuestionReader questionReader = QuestionReader(settings, progression);
    await questionReader.readCourseQuestions(course);
    Questions _questions = questionReader.questions;

    progression.setQuestionCount(_questions.totalAmountOfQuestions, course);

    NavigationHelper.goToQuizPage(context, course, _questions);
  }

  static void goToQuizPage(
      BuildContext context, Course course, [Questions questions]) {
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

  static void goToLeaderboardPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LeaderBoardPage()));
  }
}
