import 'package:flutter/material.dart';

void main() {
  runApp(SurveyPage());
}

class SurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF48B5BB),
          title: Text(
            "설문에 답하기",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SurveyBody(),
        backgroundColor: Color(0xFFD9EEF1),
      ),
    );
  }
}

class SurveyBody extends StatefulWidget {
  @override
  _SurveyBodyState createState() => _SurveyBodyState();
}

class _SurveyBodyState extends State<SurveyBody> {
  bool submitted = false;

  late List<bool> answers; // 각 질문에 대한 답변을 저장할 리스트

  @override
  void initState() {
    super.initState();
    answers = List.filled(questions.length, false);
  }

  bool canSubmit() {
    // 필수 질문에 대한 답변 여부 확인
    for (int i = 0; i < questions.length; i++) {
      if (questions[i]["required"] == true && !answers[i]) {
        return false; // 필수 질문에 답하지 않은 경우
      }
    }
    return true; // 모든 필수 질문에 답했을 때
  }

  void submitSurvey() {
    setState(() {
      submitted = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("설문 제출", style: TextStyle(color: Colors.white)),
          content: Text(
            "설문을 제출하시겠습니까? 한 번 제출한 이후에는 다시 제출할 수 없습니다.",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xFFD9EEF1),
          contentPadding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0), // 높이 조절
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFF48B5BB), // 수정
                ),
                child: Text(
                  "취소",
                  style: TextStyle(color: Colors.white), // 수정
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 여기에 제출 로직 추가
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFF48B5BB), // 수정
                ),
                child: Text(
                  "제출",
                  style: TextStyle(color: Colors.white), // 수정
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    // 모임 정보 (DB에서 받아옴)
    String groupName = "모임 이름";
    String surveyTitle = "설문 제목";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 모임 정보 컨테이너
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "모임 이름: $groupName",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "설문 제목: $surveyTitle",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // 질문 목록 리스트뷰
        Expanded(
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return QuestionContainer(
                number: questions[index]["number"],
                content: questions[index]["content"],
                multipleChoice: questions[index]["multipleChoice"] ?? false,
                choices: questions[index]["choices"],
                required: questions[index]["required"] ?? false,
                onAnswered: (answer) {
                  setState(() {
                    answers[index] = answer;
                  });
                },
              );
            },
          ),
        ),
        // 설문 제출 버튼
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ElevatedButton(
              onPressed: canSubmit() ? () => submitSurvey() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF48B5BB), // 버튼 색상
              ),
              child: Text(
                "설문 제출",
                style: TextStyle(color: Colors.white), // 글씨 색상
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class QuestionContainer extends StatefulWidget {
  final int number;
  final String content;
  final bool multipleChoice;
  final List<String>? choices;
  final bool required;
  final Function(bool)? onAnswered;

  QuestionContainer({required this.number, required this.content, required this.multipleChoice, this.choices, required this.required, this.onAnswered});

  @override
  _QuestionContainerState createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  String? selectedChoice;
  bool answered = false;

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
            "질문 ${widget.number}:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            widget.content,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          if (widget.multipleChoice && widget.choices != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.choices!.map((choice) {
                return Row(
                  children: [
                    Radio<String>(
                      value: choice,
                      groupValue: selectedChoice,
                      onChanged: (value) {
                        setState(() {
                          selectedChoice = value;
                          widget.onAnswered?.call(true);
                        });
                      },
                    ),
                    Text(choice),
                  ],
                );
              }).toList(),
            ),
          if (!widget.multipleChoice)
            TextField(
              decoration: InputDecoration(
                hintText: "답변을 입력하세요",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    answered = true;
                  });
                  widget.onAnswered?.call(true);
                } else {
                  setState(() {
                    answered = false;
                  });
                  widget.onAnswered?.call(false);
                }
              },
            ),
          if (widget.required && !answered)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "필수로 답변해야 합니다.",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> questions = [
  {"number": 1, "content": "이 설문에 대한 의견을 적어주세요.", "required": false},
  {"number": 2, "content": "어떤 항목이 가장 중요하다고 생각하십니까?", "required": true, "multipleChoice": true, "choices": ["항목 A", "항목 B", "항목 C"]},
  {"number": 3, "content": "설문에 대한 추가 의견이 있으십니까?", "required": false},
];
