import 'package:flutter/material.dart';
import 'package:project_team8/fee_result.dart';
import 'package:project_team8/survey_result.dart';

void main() {
  runApp(ClickedApp());
}

class ClickedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final int surveyId = args['surveyId'];
    final int userId = args['userId'];
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF48B5BB), // 앱바 색상
        ),
        scaffoldBackgroundColor: Color(0xFFD9EEF1), // 앱 배경색
      ),
      home: SurveyPage(surveyId: surveyId, userId: userId),
      routes: {
        '/result' : (context) => SurveyResult()
      },
    );
  }
}

class SurveyPage extends StatelessWidget {
  final int surveyId;
  final int userId;

  SurveyPage({required this.surveyId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '설문 결과 조회', // 앱바 제목
          style: TextStyle(color: Colors.white), // 앱바 글씨색
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    '/result',
                    arguments: {'userId': userId, 'surveyId': surveyId},
                  );// 설문 결과 버튼이 눌렸을 때의 동작
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF48B5BB), // 버튼 배경색
                  padding: EdgeInsets.zero, // 버튼 내부 간격 제거
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 버튼 모서리를 둥글게 만듦
                  ),
                ),
                child: Text(
                  '설문 결과',
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 색상
                ),
              ),
            ),
            SizedBox(height: 200), // 버튼 간격 조정
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentStatusPage()),
                  );// 회부 납부 내역 버튼이 눌렸을 때의 동작
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF48B5BB), // 버튼 배경색
                  padding: EdgeInsets.zero, // 버튼 내부 간격 제거
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 버튼 모서리를 둥글게 만듦
                  ),
                ),
                child: Text(
                  '회부 납부 내역',
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 색상
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}