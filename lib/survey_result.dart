import 'package:flutter/material.dart';

void main() {
  runApp(SurveyResultPage());
}

class SurveyResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF48B5BB),
          title: Text(
            "설문 결과",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SurveyResultBody(),
        backgroundColor: Color(0xFFD9EEF1),
      ),
    );
  }
}

class SurveyResultBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 모임 정보를 DB에서 받아온다고 가정
    String groupName = "모임 이름";
    String surveyTitle = "설문 제목";
    int totalParticipants = 100; // 총 참여자 수

    // 질문과 답안
    List<Map<String, dynamic>> surveyResults = [
      {"questionNumber": 1, "question": "이 설문조사는 어떤 주제에 관한 것입니까?", "answer": "객관식", "options": ["옵션 1", "옵션 2", "옵션 3", "옵션 4"], "responses": [30, 25, 15, 30]},
      {"questionNumber": 2, "question": "이 설문조사는 어떤 목적으로 진행되었습니까?", "answer": "주관식", "response": "예시 답안"},
      // 추가 질문과 답안은 필요에 따라 계속해서 추가할 수 있습니다.
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 모임 정보 컨테이너
        Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                surveyTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "총 참여자 수: $totalParticipants",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        // 질문 및 답변 컨테이너 리스트뷰
        Expanded(
          child: ListView.builder(
            itemCount: surveyResults.length,
            itemBuilder: (BuildContext context, int index) {
              return SurveyItem(
                questionNumber: surveyResults[index]['questionNumber'],
                question: surveyResults[index]['question'],
                answer: surveyResults[index]['answer'],
                options: surveyResults[index]['options'],
                responses: surveyResults[index]['responses'],
                response: surveyResults[index]['response'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class SurveyItem extends StatelessWidget {
  final int questionNumber;
  final String question;
  final String answer;
  final List<String>? options;
  final List<int>? responses;
  final String? response;

  SurveyItem({required this.questionNumber, required this.question, required this.answer, this.options, this.responses, this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "질문 $questionNumber:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            question,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            "답변:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          if (answer == "객관식")
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: options!.length,
              itemBuilder: (BuildContext context, int index) {
                double percentage = responses![index] / responses!.reduce((a, b) => a + b) * 100;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${options![index]} (${responses![index]}명, ${percentage.toStringAsFixed(1)}%)",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      width: MediaQuery.of(context).size.width * (percentage / 100),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              },
            )
          else
            Text(
              response!,
              style: TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }
}
