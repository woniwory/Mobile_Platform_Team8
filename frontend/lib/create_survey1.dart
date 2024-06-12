
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_team8/app_main.dart';
import 'package:project_team8/app_main1.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

void main() {
  runApp(SurveyApp());
}

class SurveyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)?.settings.arguments as int;
    print(userId);
    return MaterialApp(
      title: 'Survey App',
      home: ChangeNotifierProvider(
        create: (context) => SurveyProvider(userId: userId),
        child: SurveyPage(userId: userId),

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
  TextEditingController requiredPaymentController = TextEditingController();
  List<Question> questions = [];
  List<TextEditingController> choiceControllers = [];
  bool questionType = false;
  bool required = false;

  final int userId;
  SurveyProvider({required this.userId});

  Future<void> addQuestion() async {
    print("addQuestion: $questionType");
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
          required: required,
          questionId: null,

        ),
      );
      choiceControllers.clear();
    } else {
      questions.add(
        Question(
          text: questionController.text,
          type: questionType,
          required: required,
          questionId: null,
        ),
      );
    }
    questionController.clear();
    required = false;
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
    required = selectedQuestion.required;
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
    selectedQuestion.type = questionType;
    selectedQuestion.required = required;
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
                      labelText: '객관식 답변 ${i + 1}',
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
          child: Text('객관식 답변 추가하기', style: TextStyle(color: Colors.black)),
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
        'required': question.required,
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
        'requiredPayment': requiredPaymentController.text
      }),
    );

    if (surveyResponse.statusCode != 200 && surveyResponse.statusCode != 201) {
      throw Exception('Failed to save survey to the database');
    }

    // Parse survey ID from the response
    final surveyId = jsonDecode(surveyResponse.body)['surveyId'];

    // Prepare questions with survey ID
    final questionsWithSurveyId = questions.map((question) {
      return {
        'surveyId': surveyId,
        'questionText': question.text,
        'type': question.type,
        'isRequired': question.required,
      };
    }).toList();

    // Send post request to save questions to the database
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
    // final List<dynamic> jsonResponse = jsonDecode(questionResponse.body);
    final questionId = jsonDecode(questionResponse.body)[0]['questionId'];
    print('Parsed JSON Response: $questionId');


    // Convert jsonResponse to list of createdQuestions
    final createdQuestions = questions.map((question) {
      return {
        'questionId': questionId,
        'questionText': question.text,
        'type': question.type,
        'required': question.required,
      };
    }).toList();

    print('Created Questions: $createdQuestions');

    // If question type is '객관식 답변', save choices
    for (var createdQuestion in createdQuestions) {
      print('Checking question type for question ID: ${createdQuestion['questionId']}');
      print(createdQuestion['type']);
      print(createdQuestion['questionText']);
      print(createdQuestion['required']);

      if (createdQuestion['type']) {
        // Find the original question to get the choices
        final originalQuestion = questions.firstWhere(
                (q) => q.text == createdQuestion['questionText'] && q.type == createdQuestion['type']);

        print(originalQuestion.type);
        print("createdQuestion['type']: ${createdQuestion['type']}");
        List<Map<String, dynamic>> choicesJson = [];
        for (var choice in originalQuestion.choices!) {
          choicesJson.add({
            'questionId': createdQuestion['questionId'],
            'choiceText': choice,
            'type': createdQuestion['type']
          });
        }

        print('Choices JSON for question ID ${createdQuestion['questionId']}: $choicesJson');

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
        print('Question type is not "객관식 답변" for question ID: ${createdQuestion['questionId']}');
      }
    }


    // Send post request to save survey to the database
    final userGroupResponse = await http.post(
      Uri.parse('http://localhost:8080/api/user-groups'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "user": {
          "userId": userId
        },
        "group": {
          "groupId": 1
        },
        "survey": {
          "surveyId": surveyId
        }

      }),
    );

    if (userGroupResponse.statusCode != 200 && userGroupResponse.statusCode != 201) {
      throw Exception('Failed to save survey to the database');
    }


    // If everything is successful, navigate to the next page
    Navigator.of(context).pushReplacementNamed('/app', arguments: userId);
  }


}

class SurveyPage extends StatefulWidget {
  final int userId;

  SurveyPage({required this.userId});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {

  @override
  Widget build(BuildContext context) {
    final userId = widget.userId;
    print(userId);
    return Scaffold(
        appBar: AppBar(
          title: Text('설문 만들기'),
          backgroundColor: Color(0xFF48B5BB),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/app', arguments: userId); // app_main1.dart로 이동
            },
          ),
        ),
        body: Container(
          color: Color(0xFFD9EEF1), // 배경 색상 변경
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<SurveyProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: provider.titleController,
                        decoration: InputDecoration(
                          labelText: '설문 제목',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '제목을 추가해주세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: provider.descriptionController,
                        decoration: InputDecoration(
                          labelText: '설문 설명',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '설명을 추가해주세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: provider.questionController,
                        decoration: InputDecoration(
                          labelText: '질문',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '질문을 추가해주세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: provider.requiredPaymentController,
                        decoration: InputDecoration(
                          labelText: '회비',
                        ),
                        keyboardType: TextInputType.number, // 숫자 입력을 위한 키보드 타입 설정
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('필수 여부'),
                          Switch(
                            value: provider.required,
                            onChanged: (value) {
                              provider.required = value;
                              provider.notifyListeners();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      DropdownButton<bool>(
                        value: provider.questionType,
                        onChanged: (newValue) {
                          setState(() {
                            provider.questionType = newValue!;
                            print("Selected value: ${provider.questionType}");
                          });
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
                        child: Text('질문 추가하기', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF48B5BB), // 버튼 색상 변경
                          minimumSize: Size(130, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      provider.questions.isEmpty
                          ? Center(child: Text('No questions added yet'))
                          : ListView.builder(
                        shrinkWrap: true, // ListView가 SingleChildScrollView 내에서 동작하도록 설정
                        physics: NeverScrollableScrollPhysics(), // SingleChildScrollView 내에서 스크롤을 막음
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
                                Text('Required: ${provider.questions[index].required ? "Yes" : "No"}'),
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
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (provider.titleController.text.isEmpty) {
                            // Display error message or validation feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('제목을 추가해주세요')),
                            );
                          }
                          else if (
                          provider.descriptionController.text.isEmpty) {
                            // Display error message or validation feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('설명을 추가해주세요')),
                            );
                          }
                          else if (
                          provider.questionController.text.isEmpty && provider.questions.isEmpty) {
                            if(provider.questionController.text.isEmpty){
                              // Display error message or validation feedback
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('질문을 추가해주세요')),
                              );
                            }
                            else if (
                            provider.questions.isEmpty) {
                              // Display error message or validation feedback
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('질문 추가하기 버튼을 눌러주세요')),
                              );
                            }
                          }
                          else if (
                          provider.questions.isEmpty) {
                            // Display error message or validation feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('질문 추가하기 버튼을 눌러주세요')),
                            );
                          }
                          else {
                            provider.finishSurvey(context);
                          }
                        },
                        child: Text('완료', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF48B5BB), // 버튼 색상 변경
                          minimumSize: Size(130, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        )
    );
  }
}


class Question {
  String text;
  bool type; // 객관식 답변인지 여부를 나타내는 boolean 타입으로 변경
  List<String>? choices;
  bool required;
  int? questionId;
  int? requiredPayment; // Nullable 타입으로 변경

  Question({
    required this.text,
    required this.type,
    this.choices,
    required this.required,
    this.questionId,
    this.requiredPayment, // Optional parameter로 변경
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // 디버깅 출력을 추가하여 서버 응답을 확인합니다.
    print('Parsing Question from JSON: $json');

    // 서버 응답에서 type 필드와 required 필드가 올바른지 확인합니다.
    bool type = json['type'] == true || json['type'] == 1;
    bool required = json['required'] == true || json['required'] == 1;

    return Question(
      questionId: json['questionId'],
      text: json['questionText'],
      type: type,
      choices: json['choices'] != null ? List<String>.from(json['choices']) : [],
      required: required,
      requiredPayment: json['requiredPayment'],
    );
  }
}
