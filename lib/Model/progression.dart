import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:programming_quiz/Controller/firestore_helper.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:scoped_model/scoped_model.dart';

class ProgressionModel extends Model {
  Query playerCollection;
  DocumentReference document;
  Map<String, dynamic> documentData;
  Map<String, dynamic> playerData;

  static ProgressionModel instance;

  ProgressionModel();

  Future<Null> getPlayerInfo(String playerNickName) async {
    playerCollection = await FirestoreHelper.getPlayerCollection(playerNickName);
    document = await FirestoreHelper.getDocumentByNickname(playerNickName);
    playerData = await FirestoreHelper.getPlayerDataFromDocument(document);
  }

  void setQuestionCount(int newCount, Course course) async {
    var courseData = playerData["courses"];

    int indexCourseToUpdate = _getCourseIndex(courseData, course);
    playerData["courses"][indexCourseToUpdate]["count"] = newCount;

    document.updateData(playerData);
  }

  int getIndexLastQuestionAnswered(Course course) {
    var courseData = playerData["courses"];

    int indexCourse = _getCourseIndex(courseData, course);
    int rightAnswers = playerData["courses"][indexCourse]["correct"];
    int wrongAnswers = playerData["courses"][indexCourse]["wrong"];

    return rightAnswers + wrongAnswers;
  }

  void incrementCorrectAnswers(Course course) {
    _incrementField(course, "correct");
  }

  void incrementWrongAnswers(Course course) {
    _incrementField(course, "wrong");
  }

  void _incrementField(Course course, String field) {
    var courseData = playerData["courses"];

    int indexCourseToUpdate = _getCourseIndex(courseData, course);
    playerData["courses"][indexCourseToUpdate][field]++;

    document.updateData(playerData);
  }

  void increaseTotalPoints(double amount) {
    playerData["points"] += amount;
    document.updateData(playerData);
  }

  int getTotalPoints() {
    return playerData["points"];
  }

  int _getCourseIndex(var courseData, course) {
    for (var i = 0; i < courseData.length; i++) {
      if (courseData[i]["name"] == course.formalName) {
        return i;
      }
    }
    throw ("Couldn't find course in firebase");
  }
}
