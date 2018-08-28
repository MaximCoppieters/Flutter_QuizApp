import 'package:programming_quiz/Controller/question_reader.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/Model/settings.dart';
import 'package:test/test.dart';

void main() {
  var path = "resource/programming_basics_questions.csv.csv";
  var reader = QuestionReader(SettingsModel());

  test("firstTestIsSingleChoice", () {
    var questions = reader.questions.list;

    expect(true, questions[0] is SingleChoiceQuestion);
  });
}