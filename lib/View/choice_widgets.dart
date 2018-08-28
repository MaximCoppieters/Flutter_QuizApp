import 'package:flutter/material.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/questions.dart';
import 'package:programming_quiz/View/utility_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class ChoiceWidget extends StatefulWidget {
  final int _choiceIndex;

  ChoiceWidget(this._choiceIndex);

  @override
  State<StatefulWidget> createState() {
    return ChoiceWidgetState(_choiceIndex);
  }
}

class ChoiceWidgetState extends State<ChoiceWidget> {
  final int _choiceIndex;

  ChoiceWidgetState(this._choiceIndex);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Question>(
        builder: (context, child, questionModel) => questionModel
        is SingleChoiceQuestion
            ? RadioButtonWidget(questionModel, _choiceIndex)
            : CheckboxWidget(questionModel, _choiceIndex));
  }
}

class RadioButtonWidget extends StatefulWidget {
  final SingleChoiceQuestion _question;
  final int _choiceIndex;

  RadioButtonWidget(this._question, this._choiceIndex);

  @override
  State<StatefulWidget> createState() {
    return RadioButtonState(_question, _choiceIndex);
  }
}

class RadioButtonState extends State<RadioButtonWidget> {
  final SingleChoiceQuestion _question;
  final int _choiceIndex;

  RadioButtonState(this._question, this._choiceIndex);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CourseModel>(
        builder: (context, child, courseModel) => RadioListTile<int>(
          controlAffinity: ListTileControlAffinity.leading,
          value: _choiceIndex,
          groupValue: _question.selectedIndex,
          activeColor: courseModel.course.mainColor,
          onChanged: (int val) {
            _question.selectedIndex = val;
          },
          title: TextTitle(text: convertQuestionNumberToChar(_choiceIndex)),
          secondary: Align(
              alignment: Alignment(1.0, 0.0),
              child:
              TextTitle(text: _question.choices[_choiceIndex])),
        ));
  }

}

String convertQuestionNumberToChar(int number) {
  return String.fromCharCode(number + 65);
}

class CheckboxWidget extends StatefulWidget {
  final MultipleChoiceQuestion _question;
  final int _choiceIndex;

  CheckboxWidget(this._question, this._choiceIndex);

  @override
  State<StatefulWidget> createState() {
    return CheckboxWidgetState(_question, _choiceIndex);
  }
}

class CheckboxWidgetState extends State<CheckboxWidget> {
  final MultipleChoiceQuestion _question;
  final int _choiceIndex;

  CheckboxWidgetState(this._question, this._choiceIndex);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CourseModel>(
        builder: (context, child, colorModel) => CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          selected: _question.containsAnswer(_choiceIndex),
          value: _question.containsAnswer(_choiceIndex),
          activeColor: colorModel.course.mainColor,
          onChanged: (bool ticked) {
            if (ticked) {
              _question.addAnswer(_choiceIndex);
            } else {
              _question.removeAnswer(_choiceIndex);
            }
          },
          title: TextTitle(text: String.fromCharCode(_choiceIndex + 65)),
          secondary:
          Center(child: TextTitle(text: _question.choices[_choiceIndex])),
        ));
  }
}
