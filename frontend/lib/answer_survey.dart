import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_team8/app_main1.dart';

void main() {
  runApp(AnswerSurvey());
}

class AnswerSurvey extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final questionId = ModalRoute.of(context)?.settings.arguments as int;

    return MaterialApp(
      title: '설문 응답하기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFD9EEF1),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF48B5BB),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF48B5BB),
            minimumSize: Size(130, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      home: SurveyQuestionsPage(questionId: questionId),
      routes: {
        '/app': (context) => MyApp(), // '/app' 경로에 대한 위젯 설정

      },
    );
  }
}

class SurveyQuestionsPage extends StatefulWidget {
  final int questionId;

  SurveyQuestionsPage({required this.questionId});
  @override
  _SurveyQuestionsPageState createState() => _SurveyQuestionsPageState();
}

class _SurveyQuestionsPageState extends State<SurveyQuestionsPage> {
  List<Map<String, dynamic>> questions = [];
  List<int?> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions(widget.questionId);
  }

  Future<void> fetchQuestions(int questionId) async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/questions/survey/$questionId'));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> fetchedQuestions = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      setState(() {
        questions = fetchedQuestions;
        print(questions);
        selectedChoices = List.generate(fetchedQuestions.length, (index) => null);
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설문 응답하기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/app');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final selectedChoice = selectedChoices[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('질문 ${index + 1}: ${question['questionText']}'),
                subtitle: question['type'] == false
                    ? TextFormField(
                  decoration: InputDecoration(labelText: 'Answer'),
                  onChanged: (value) {
                    setState(() {
                      question['responseText'] = value;
                    });
                  },
                )
                    : FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchChoices(question['questionId']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Failed to load choices');
                    } else {
                      final choices = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: choices.map((choice) {
                          final int choiceId = choice['choiceId'];
                          return RadioListTile<int>(
                            title: Text(choice['choiceText']),
                            value: choiceId,
                            groupValue: selectedChoice,
                            onChanged: (int? value) {
                              setState(() {
                                selectedChoices[index] = value;
                                print(value);

                              });
                            },
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 8),
            ],
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          finishSurvey();
        },
        child: Text('응답 완료', style: TextStyle(color: Colors.black)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<List<Map<String, dynamic>>> fetchChoices(int questionId) async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/choices/question/$questionId'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load choices');
    }
  }

  Future<void> finishSurvey() async {
    final List<Map<String, dynamic>> responses = questions.map((question) {
      final int questionIndex = questions.indexOf(question);
      final selectedChoice = selectedChoices[0];
      print("selectedChoice $selectedChoice");

      return {
        'questionId': question['questionId'],
        'userId': 1, // Placeholder for user
        "choiceId": selectedChoice,
        'responseText': question['responseText'],
      };
    }).toList();


    final response = await http.post(
      Uri.parse('http://localhost:8080/api/responses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(responses),
    );
    print("response ${response}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Survey completed successfully');
      Navigator.of(context).pushReplacementNamed('/app');
    } else {
      print('Failed to complete survey');
    }
  }
}
