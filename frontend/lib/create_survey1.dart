import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_team8/app_main.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SurveyApp());
}

class SurveyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey App',
      home: ChangeNotifierProvider(
        create: (context) => SurveyProvider(),
        child: SurveyPage(),
      ),
      routes: {
        '/app': (context) => MyApp(),
      },
    );
  }
}
class SurveyProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController choiceController = TextEditingController();
  List<Question> questions = [];
  List<TextEditingController> choiceControllers = [];
  bool questionType = false;
  bool isRequired = false;

  Future<void> addQuestion() async {
    if (questionType) {
      List<String> choices = [];
      for (var controller in choiceControllers) {
        choices.add(controller.text);
      }
      questions.add(
        Question(
          text: questionController.text,
          type: questionType,
          choices: choices,
          isRequired: isRequired,
          questionId: null,
        ),
      );
      choiceControllers.clear();
    } else {
      questions.add(
        Question(
          text: questionController.text,
          type: questionType,
          isRequired: isRequired,
          questionId: null,
        ),
      );
    }
    questionController.clear();
    isRequired = false;
    notifyListeners();
  }

  void addChoiceController(BuildContext context) {
    choiceControllers.add(TextEditingController());
    notifyListeners();
  }

  void deleteChoiceController(int index) {
    choiceControllers.removeAt(index);
    notifyListeners();
  }

  void editQuestion(int index) {
    Question selectedQuestion = questions[index];
    questionController.text = selectedQuestion.text;
    questionType = selectedQuestion.type;
    isRequired = selectedQuestion.isRequired;
    if (questionType) {
      choiceControllers.clear();
      selectedQuestion.choices?.forEach((choice) {
        TextEditingController controller = TextEditingController(text: choice);
        choiceControllers.add(controller);
      });
    } else {
      choiceControllers.clear();
    }
    notifyListeners();
  }

  void saveEditedQuestion(int index) {
    Question selectedQuestion = questions[index];
    selectedQuestion.text = questionController.text;
    selectedQuestion.type = questionType; // Ensure this line updates the questionType
    selectedQuestion.isRequired = isRequired;
    if (questionType) {
      selectedQuestion.choices = choiceControllers.map((controller) => controller.text).toList();
    }
    notifyListeners();
  }

  void deleteQuestion(int index) {
    questions.removeAt(index);
    notifyListeners();
  }

  void changeQuestionType(bool newValue) {
    questionType = newValue;
    print("Question type changed to: $questionType");
    notifyListeners();
  }

  List<DropdownMenuItem<bool>> buildDropdownMenuItems() {
    return [
      DropdownMenuItem<bool>(
        value: false,
        child: Text('서술형 답변'),
      ),
      DropdownMenuItem<bool>(
        value: true,
        child: Text('객관식 답변'),
      ),
    ];
  }

  Widget buildChoiceFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < choiceControllers.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: choiceControllers[i],
                    decoration: InputDecoration(
                      labelText: 'Choice ${i + 1}',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    deleteChoiceController(i);
                  },
                ),
              ],
            ),
          ),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {
            addChoiceController(context);
          },
          child: Text('Add Choice'),
        ),
      ],
    );
  }

  void finishSurvey(BuildContext context) async {
    // Convert questions to JSON
    List<Map<String, dynamic>> questionsJsonList = [];
    for (var question in questions) {
      questionsJsonList.add({
        'questionText': question.text,
        'type': question.type,
        'choices': question.choices,
        'isRequired': question.isRequired,
      });
    }

    // Get current date for start and end dates
    final now = DateTime.now();
    final surveyStartDate = now.toUtc().toIso8601String();
    final surveyEndDate = now.add(Duration(days: 1)).toUtc().toIso8601String();

    // Send post request to save survey to the database
    final surveyResponse = await http.post(
      Uri.parse('http://localhost:8080/surveys'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'surveyTitle': titleController.text,
        'surveyDescription': descriptionController.text,
        'surveyStartDate': surveyStartDate,
        'surveyEndDate': surveyEndDate,
        'participants': 0,
      }),
    );

    if (surveyResponse.statusCode != 200 && surveyResponse.statusCode != 201) {
      throw Exception('Failed to save survey to the database');
    }

    // Parse survey ID from the response
    final surveyId = jsonDecode(surveyResponse.body)['surveyId'];

    // Send post request to save questions to the database
    final questionsWithSurveyId = questions.map((question) {
      return {
        'surveyId': surveyId,
        'questionText': question.text,
        'type': question.type,
        'isRequired': question.isRequired,
      };
    }).toList();

    final questionResponse = await http.post(
      Uri.parse('http://localhost:8080/api/questions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(questionsWithSurveyId),
    );

    if (questionResponse.statusCode != 200 && questionResponse.statusCode != 201) {
      throw Exception('Failed to save question to the database');
    }

    // Log the raw response body
    print('Question Response Body: ${questionResponse.body}');

    // Parse created questions from the response
    final List<dynamic> jsonResponse = jsonDecode(questionResponse.body);
    print('Parsed JSON Response: $jsonResponse');

    final createdQuestions = jsonResponse.map((json) => Question.fromJson(json)).toList();
    print('Created Questions: $createdQuestions');

    // If question type is '객관식 답변', save choices
    for (var createdQuestion in createdQuestions) {
      print('Checking question type for question ID: ${createdQuestion.questionId}');
      print(createdQuestion.type);

      if (createdQuestion.type) {
        // Find the original question to get the choices
        final originalQuestion = questions.firstWhere((q) => q.text == createdQuestion.text && q.type == createdQuestion.type);

        List<Map<String, dynamic>> choicesJson = [];
        for (var choice in originalQuestion.choices!) {
          choicesJson.add({
            'questionId': createdQuestion.questionId,
            'choiceText': choice,
          });
        }

        print('Choices JSON for question ID ${createdQuestion.questionId}: $choicesJson');

        try {
          final choiceResponse = await http.post(
            Uri.parse('http://localhost:8080/api/choices'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(choicesJson),
          );

          print('choice Response Status Code: ${choiceResponse.statusCode}');
          print('choice Response Body: ${choiceResponse.body}');

          if (choiceResponse.statusCode != 200 && choiceResponse.statusCode != 201) {
            throw Exception('Failed to save choices to the database');
          }
        } catch (e) {
          print('HTTP request failed: $e');
        }
      } else {
        print('Question type is not "객관식 답변" for question ID: ${createdQuestion.questionId}');
      }
    }

    // If everything is successful, navigate to the next page
    Navigator.of(context).pushReplacementNamed('/app');
  }
}

class SurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Page'),
        backgroundColor: Color(0xFF48B5BB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SurveyProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: provider.titleController,
                  decoration: InputDecoration(
                    labelText: 'Survey Title',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: provider.descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Survey Description',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: provider.questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Required'),
                    Switch(
                      value: provider.isRequired,
                      onChanged: (value) {
                        provider.isRequired = value;
                        provider.notifyListeners();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                DropdownButton<bool>(
                  value: provider.questionType,
                  onChanged: (newValue) {
                    print("Dropdown value changed to: $newValue");
                    provider.changeQuestionType(newValue!);
                  },
                  items: provider.buildDropdownMenuItems(),
                ),
                SizedBox(height: 16),
                if (provider.questionType) provider.buildChoiceFields(context),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.addQuestion();
                  },
                  child: Text('Add Question'),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Question ${index + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Text: ${provider.questions[index].text}'),
                            Text('Type: ${provider.questions[index].type ? "객관식 답변" : "서술형 답변"}'),
                            if (provider.questions[index].choices != null &&
                                provider.questions[index].type)
                              Text('Choices: ${provider.questions[index].choices!.join(", ")}'),
                            Text('Required: ${provider.questions[index].isRequired ? "Yes" : "No"}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                provider.editQuestion(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                provider.deleteQuestion(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () {
                                provider.saveEditedQuestion(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.finishSurvey(context);
                  },
                  child: Text('Finish Create Survey'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class Question {
  String text;
  bool type;
  List<String>? choices;
  bool isRequired;
  int? questionId;

  Question({
    required this.text,
    required this.type,
    this.choices,
    required this.isRequired,
    this.questionId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
      text: json['questionText'],
      type: json['type'] == true,
      choices: json['choices'] != null ? List<String>.from(json['choices']) : [],
      isRequired: json['isRequired'],
    );
  }
}

