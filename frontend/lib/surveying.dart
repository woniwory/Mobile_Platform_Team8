import 'package:flutter/material.dart';

void main() {
  runApp(SurveyAnsweringApp());
}

class SurveyAnsweringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey Answering App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SurveyAnsweringPage(),
    );
  }
}

class SurveyAnsweringPage extends StatefulWidget {
  @override
  _SurveyAnsweringPageState createState() => _SurveyAnsweringPageState();
}

class _SurveyAnsweringPageState extends State<SurveyAnsweringPage> {
  List<String> selectedChoices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Answering Page'),
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
            Text(
              'Question 1: What is your favorite color?',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Question 2: Which programming languages do you know?',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            CheckboxListTile(
              title: Text('Python'),
              value: selectedChoices.contains('Python'),
              onChanged: (value) {
                setState(() {
                  if (value!)
                    selectedChoices.add('Python');
                  else
                    selectedChoices.remove('Python');
                });
              },
            ),
            CheckboxListTile(
              title: Text('Java'),
              value: selectedChoices.contains('Java'),
              onChanged: (value) {
                setState(() {
                  if (value!)
                    selectedChoices.add('Java');
                  else
                    selectedChoices.remove('Java');
                });
              },
            ),
            CheckboxListTile(
              title: Text('JavaScript'),
              value: selectedChoices.contains('JavaScript'),
              onChanged: (value) {
                setState(() {
                  if (value!)
                    selectedChoices.add('JavaScript');
                  else
                    selectedChoices.remove('JavaScript');
                });
              },
            ),
            SizedBox(height: 16.0),
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
