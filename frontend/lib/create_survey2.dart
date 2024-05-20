import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class Survey {
  final String title;
  final List<Question> questions;

  Survey({required this.title, required this.questions});

  factory Survey.fromJson(Map<String, dynamic> json) {
    List<dynamic> questionsJson = json['questions'];
    List<Question> parsedQuestions =
    questionsJson.map((q) => Question.fromJson(q)).toList();

    return Survey(title: json['title'], questions: parsedQuestions);
  }
}

class Question {
  final String text;
  final String type;
  final List<String>? choices;

  Question({required this.text, required this.type, this.choices});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<dynamic>? choicesJson = json['choices'];
    List<String>? parsedChoices =
    choicesJson?.map((choice) => choice.toString()).toList();

    return Question(
      text: json['text'],
      type: json['type'],
      choices: parsedChoices,
    );
  }
}

void main() {
  runApp(SurveyExecutionApp());
}

class SurveyExecutionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey Execution App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SurveyExecutionPage(),
    );
  }
}

class SurveyExecutionPage extends StatefulWidget {
  @override
  _SurveyExecutionPageState createState() => _SurveyExecutionPageState();
}

class _SurveyExecutionPageState extends State<SurveyExecutionPage> {
  late List<Question> questions;

  @override
  void initState() {
    super.initState();
    loadSurveyFromJson(); // 설문 파일을 불러오는 메서드 호출
  }

  void loadSurveyFromJson() async {
    // 설문 파일을 읽어오는 비동기 메서드
    String jsonString = await File('survey.json').readAsString();
    Map<String, dynamic> json = jsonDecode(jsonString);
    Survey survey = Survey.fromJson(json);
    setState(() {
      questions = survey.questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Execution Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Survey Title',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}: ${questions[index].text}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    if (questions[index].type == '객관식 답변')
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: questions[index].choices!.length,
                        itemBuilder: (context, choiceIndex) {
                          return RadioListTile(
                            title: Text(questions[index].choices![choiceIndex]),
                            value: questions[index].choices![choiceIndex],
                            groupValue: null, // 선택된 값에 따라 변경
                            onChanged: (value) {
                              // 선택된 값에 따라 변경 로직 추가
                            },
                          );
                        },
                      )
                    else
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your answer',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    SizedBox(height: 16.0),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Submit answers
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
