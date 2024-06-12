import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

void main() {
  runApp(SurveyResult());
}

class SurveyResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SurveyQuestions(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFD9EEF1), // 앱의 배경색 지정
      ),
    );
  }
}

class SurveyQuestions extends StatefulWidget {
  @override
  _SurveyQuestionsState createState() => _SurveyQuestionsState();
}

class _SurveyQuestionsState extends State<SurveyQuestions> with SingleTickerProviderStateMixin {
  List<dynamic> questions = [];
  List<int> questionIds = []; // 질문 ID를 저장할 리스트
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    fetchQuestions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    final response = await http.get(Uri.parse("http://localhost:8080/api/questions/survey/1"));

    if (response.statusCode == 200) {
      setState(() {
        questions = json.decode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩

        // 질문 ID를 저장
        questionIds = questions.map<int>((question) => question['questionId']).toList();
      });

      // 애니메이션 시작
      _controller.forward();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설문 결과 조회', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF48B5BB), // AppBar의 색상 지정
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final questionText = question['questionText'];
          final responseType = question['type'];
          final responsesUrl = "http://localhost:8080/api/responses/question/${questionIds[index]}"; // 질문 ID 리스트를 사용하여 동적으로 URL 생성

          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("질문 ${index + 1}: $questionText", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                responseType ? FutureBuilder(
                  future: fetchResponses(responsesUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      final responseData = snapshot.data as List<dynamic>? ?? [];
                      final choices = responseData.where((response) => response['choice'] != null).toList();
                      final descriptiveResponses = responseData.where((response) => response['responseText'] != null).toList();
                      final totalResponses = choices.length;

                      // 객관식 선택지 비율 계산
                      final choiceCounts = <String, int>{};
                      for (var choice in choices) {
                        final choiceText = choice['choice']['choiceText'];
                        if (choiceCounts.containsKey(choiceText)) {
                          choiceCounts[choiceText] = choiceCounts[choiceText]! + 1;
                        } else {
                          choiceCounts[choiceText] = 1;
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (choiceCounts.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i = 0; i < choiceCounts.entries.length; i++)
                                  Text("문항${i + 1}: ${choiceCounts.entries.elementAt(i).key}: ${choiceCounts.entries.elementAt(i).value}명의 응답자가 있습니다"),
                                SizedBox(height: 10),
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      size: Size(200, 200), // 원형 그래프의 크기 지정
                                      painter: PieChartPainter(choiceCounts, _controller.value),
                                    );
                                  },
                                ),
                                SizedBox(height: 10),
                                // 범례 추가
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var entry in choiceCounts.entries)
                                      Text("${entry.key}: ${(entry.value / totalResponses * 100).toStringAsFixed(2)}%"),
                                  ],
                                ),
                              ],
                            ),

                          if (descriptiveResponses.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i = 0; i < descriptiveResponses.length; i++)
                                  Text("Response ${i + 1}: ${descriptiveResponses[i]['responseText']}"),
                              ],
                            ),
                        ],
                      );
                    }
                  },
                ) : FutureBuilder(
                  future: fetchResponses(responsesUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      final responseData = snapshot.data as List<dynamic>? ?? [];
                      final descriptiveResponses = responseData.where((response) => response['responseText'] != null).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (descriptiveResponses.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i = 0; i < descriptiveResponses.length; i++)
                                  Text("Response ${i + 1}: ${descriptiveResponses[i]['responseText']}"),
                              ],
                            ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<List<dynamic>> fetchResponses(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩
    } else {
      throw Exception('Failed to load responses');
    }
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, int> data;
  final double animationValue;

  PieChartPainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold(0, (sum, value) => sum + value);
    double startAngle = -90.0;

    final paint = Paint()
      ..style = PaintingStyle.fill;

    data.forEach((key, value) {
      final sweepAngle = (value / total) * 360 * animationValue;
      paint.color = _getColor(key); // 항목에 따라 색상 설정
      canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height),
        _degreesToRadians(startAngle),
        _degreesToRadians(sweepAngle),
        true,
        paint,
      );
      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  Color _getColor(String key) {
    // 항목에 따라 색상을 반환하는 함수
    // 필요에 따라 색상을 추가
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
      Colors.teal,
      Colors.lime,
    ];
    return colors[data.keys.toList().indexOf(key) % colors.length];
  }
}
