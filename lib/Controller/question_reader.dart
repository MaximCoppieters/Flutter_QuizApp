import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/progression.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/Model/settings.dart';

class QuestionReader {
  final Questions _questions;
  Questions get questions => _questions;
  final SettingsModel _userSettings;
  final ProgressionModel _progression;

  static QuestionReader _instance;

  QuestionReader._internal(this._userSettings, this._progression) : _questions = Questions();

  factory QuestionReader(SettingsModel settings, ProgressionModel progression) {
    if (_instance == null) {
      return QuestionReader._internal(settings, progression);
    }
    return _instance;
  }

  static Future<String> loadCsvAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<Null> readCourseQuestions(Course course) async {
    String questionCSVFile = await loadCsvAsset(course.csvPath);

    List<String> questionCSVLines = questionCSVFile.split("\n");

    _questions.totalAmountOfQuestions = questionCSVLines.length;
    int indexLastQuestionAnswered = _progression.getIndexLastQuestionAnswered(course);

    for (int i=indexLastQuestionAnswered; i < questionCSVLines.length; i++) {
      _readQuestion(questionCSVLines[i]);
    }
  }

  void _readQuestion(String questionLine) {
    if (questionLine == "") return;
    List<String> dataSeparated = questionLine.split(',');

    bool isMultipleChoice = dataSeparated[0] == "m";
    if ((isMultipleChoice && _userSettings.singleChoiceOnlyEnabled)
      || (!isMultipleChoice && _userSettings.multiChoiceOnlyEnabled)) {
      return;
    }

    String problemPrefix = dataSeparated[1];
    String problemImagePath = dataSeparated[2];
    String questionPhrase = dataSeparated[3];
    int choiceCount = int.parse(dataSeparated[4]);

    List<String> choices = [];
    int index;
    for (index = 5; index < 5 + choiceCount; index++) {
      choices.add(dataSeparated[index]);
    }

    Question currentQuestion;

    if (isMultipleChoice) {
      List<int> correctAnswers = [];
      for (var i = index; i < dataSeparated.length; i++) {
        correctAnswers.add(int.parse(dataSeparated[i]));
      }
      currentQuestion = MultipleChoiceQuestion(problemPrefix, problemImagePath, questionPhrase, choices, correctAnswers);
    } else {
      int correctAnswerIndex = int.parse(dataSeparated[index]);

      currentQuestion = SingleChoiceQuestion(problemPrefix, problemImagePath, questionPhrase, choices, correctAnswerIndex);
    }

    _questions.add(currentQuestion);
  }
}