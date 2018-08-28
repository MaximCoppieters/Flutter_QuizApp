import 'package:flutter/material.dart';
import 'package:programming_quiz/Model/constants.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:scoped_model/scoped_model.dart';

class Course {
  static const PROGRAMMING_BASICS = const Course(
      "Programming Basics",
      "resource/programming_basics_questions.csv",
      Constants.programmingBasicsColor,
      Constants.programmingBasicsAccentColor,
    "images/programmingicon.png"
  );
  static const JAVA_ESSENTIALs = const Course(
      "Java Essentials",
      "resource/java_essentials_questions.csv",
      Constants.javaColor,
      Constants.javaAccentColor,
    "images/javaicon.png"
  );
  static const DOTNET_ESSENTIALS = const Course(
      ".NET Essentials",
      "resource/.NET_questions.csv",
      Constants.dotNetColor,
      Constants.dotNetAccentColor,
    "images/dotneticon.png"
  );

  static const List<Course> values = [PROGRAMMING_BASICS, JAVA_ESSENTIALs, DOTNET_ESSENTIALS];

  final String _formalName;
  final String _csvPath;
  final MaterialColor _courseMainColor;
  final Color _accentColor;
  final String _imagePath;

  String get formalName => _formalName;
  String get csvPath => _csvPath;
  MaterialColor get mainColor => _courseMainColor;
  Color get accentColor => _accentColor;
  String get imagePath => _imagePath;

  const Course(this._formalName, this._csvPath, this._courseMainColor,
      this._accentColor, this._imagePath);

  static Course getCourseByFormalName(String formalName) {
    return values.singleWhere((course) => course._formalName == formalName);
  }

  String toString() {
    return _formalName;
  }
}

class CourseModel extends Model {
  Course _course;

  Course get course => _course;

  CourseModel(this._course);
}

