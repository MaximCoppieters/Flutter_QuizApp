import 'dart:async';

import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/progression.dart';
import 'package:quiver/async.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:collection/collection.dart';

abstract class Question extends Model {
  final String _problemPrefix;
  final String _problem;
  final String _questionPhrase;
  final List<String> _choices;

  int _selectedIndex = 0;
  bool _questionAnsweredCorrectly;
  int _timeRemaining;
  Timer _timer;
  Timer _secondsTimer;

  get problemPrefix => _problemPrefix;
  get problem => _problem;
  get questionPhrase => _questionPhrase;
  get choices => _choices;
  get selectedIndex => _selectedIndex;
  get questionAnsweredCorrectly => _questionAnsweredCorrectly;
  get timeRemaining => _timeRemaining;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void resetAnsweredQuestion() => _questionAnsweredCorrectly = null;

  void decrementTimeRemaining() {
    _timeRemaining--;
  }

  Question(
      this._problemPrefix, this._problem, this._questionPhrase, this._choices);

  void checkAnswer(ProgressionModel progression, CourseModel course);

  void setTimer() {
    _timeRemaining = 30;
    _timer = Timer(Duration(seconds: _timeRemaining+1), () => _questionAnsweredCorrectly = false);
  }
}

class MultipleChoiceQuestion extends Question {
  List<int> _correctAnswerIndices;
  List<int> _selectedIndices;

  List<int> get correctAnswerIndices => _correctAnswerIndices;
  List<int> get selectedIndices => _selectedIndices;

  MultipleChoiceQuestion(String problemPrefix, String _problem,
      String questionPhrase, List<String> choices, this._correctAnswerIndices)
      : super(problemPrefix, _problem, questionPhrase, choices) {
    _selectedIndices = [];
  }

  @override
  void checkAnswer(ProgressionModel progression, CourseModel courseModel) {
    _timer?.cancel();
    _secondsTimer?.cancel();

    _correctAnswerIndices.sort();
    _selectedIndices.sort();

    _questionAnsweredCorrectly =
        ListEquality().equals(_correctAnswerIndices, _selectedIndices);

    if(_questionAnsweredCorrectly) {
      progression.incrementCorrectAnswers(courseModel.course);
    } else {
      progression.incrementWrongAnswers(courseModel.course);
    }

    notifyListeners();
  }

  void addAnswer(int index) {
    _selectedIndices.add(index);
    notifyListeners();
  }

  void removeAnswer(int index) {
    _selectedIndices.removeWhere((answer) => answer == index);
    notifyListeners();
  }

  bool containsAnswer(int index) => _selectedIndices.contains(index);
}

class SingleChoiceQuestion extends Question {
  int _rightAnswerIndex;

  int get rightAnswerIndex => _rightAnswerIndex;

  SingleChoiceQuestion(String problemPrefix, String _problem,
      String questionPhrase, List<String> choices, this._rightAnswerIndex)
      : super(problemPrefix, _problem, questionPhrase, choices);

  @override
  void checkAnswer(ProgressionModel progression, CourseModel courseModel) {
    _timer?.cancel();
    _secondsTimer?.cancel();

    _questionAnsweredCorrectly = _rightAnswerIndex == _selectedIndex;
    print(progression);

    if (_questionAnsweredCorrectly) {
      progression.incrementCorrectAnswers(courseModel.course);
    } else {
      progression.incrementWrongAnswers(courseModel.course);
    }

    notifyListeners();
  }
}

class Questions {
  List<Question> _questions;
  List<Question> get list => _questions;
  int _index = 0;

  int get questionNumber => _index;
  int get count => _questions.length;

  Questions() : _questions = [];

  void add(Question question) {
    _questions.add(question);
  }


  Question getNext() {
    if (_index >= _questions.length) {
      return null;
    }
    return _questions[_index++];
  }

  bool hasNext() => _questions[++_index] != null;
}
