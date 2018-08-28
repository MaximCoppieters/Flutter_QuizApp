import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/Model/settings.dart';

class QuestionReader {
  Questions _questions;
  Questions get questions => _questions;
  SettingsModel userSettings;
  static QuestionReader _instance;

  QuestionReader._internal(this.userSettings) {
    _questions = Questions();
  }

  factory QuestionReader(SettingsModel settings) {
    if (_instance == null) {
      return QuestionReader._internal(settings);
    }
    return _instance;
  }

  static Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<Null> readQuestionsFromFile(String path) async {
    String questionCSVFile = await loadAsset(path);

    List<String> questionCSVLines = questionCSVFile.split("\n");

    for (String questionCSVLine in questionCSVLines) {
      _readQuestion(questionCSVLine);
    }
  }

  void _readQuestion(String questionLine) {
    if (questionLine == "") return;
    List<String> dataSeparated = questionLine.split(',');

    bool isMultipleChoice = dataSeparated[0] == "m";
    if ((isMultipleChoice && userSettings.singleChoiceOnlyEnabled)
      || (!isMultipleChoice && userSettings.multiChoiceOnlyEnabled)) {
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