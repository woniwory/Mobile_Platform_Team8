import 'package:flutter/material.dart';
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
    );
  }
}

class SurveyProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController choiceController = TextEditingController();
  List<Question> questions = [];
  List<TextEditingController> choiceControllers = [];
  String questionType = '서술형 답변';
  String selectedChoice = 'Add Choice';
  bool showChoicesDropdown = false;
  bool isRequired = false; // 질문 필수 여부

  void addQuestion() {
    if (questionType == '객관식 답변') {
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
        ),
      );
      choiceControllers.clear();
      selectedChoice = 'Add Choice';
      showChoicesDropdown = false;
    } else {
      questions.add(
        Question(
          text: questionController.text,
          type: questionType,
          isRequired: isRequired,
        ),
      );
    }
    questionController.clear();
    isRequired = false; // 질문 추가 후 필수 여부 초기화
    notifyListeners();
  }

  void addChoiceController(BuildContext context) {
    choiceControllers.add(TextEditingController());
    showChoicesDropdown = true;
    notifyListeners();
  }

  void deleteChoiceController(int index) {
    choiceControllers.removeAt(index);
    notifyListeners();
  }

  void editQuestion(int index) {
    // 선택한 질문의 정보 가져오기
    Question selectedQuestion = questions[index];
    questionController.text = selectedQuestion.text;
    questionType = selectedQuestion.type;
    isRequired = selectedQuestion.isRequired; // 수정: 선택한 질문의 필수 여부 가져오기

    // 질문의 타입이 객관식 답변인 경우
    if (questionType == '객관식 답변') {
      // 기존의 선택한 질문의 선택지를 가져와서 choiceControllers에 추가
      choiceControllers.clear(); // 선택한 질문을 수정할 때마다 choiceControllers를 비워줌
      selectedQuestion.choices?.forEach((choice) {
        TextEditingController controller = TextEditingController(text: choice);
        choiceControllers.add(controller);
      });
    } else {
      // 객관식 답변가 아닌 경우에는 choiceControllers를 비움
      choiceControllers.clear();
    }

    // 변경 사항 알리기
    notifyListeners();
  }

  void saveEditedQuestion(int index) {
    // 선택한 질문의 정보 가져오기
    Question selectedQuestion = questions[index];
    // 선택한 질문의 수정된 내용 저장
    selectedQuestion.text = questionController.text;
    selectedQuestion.type = questionType;
    selectedQuestion.isRequired = isRequired; // 수정: 필수 여부 저장

    // 선택한 질문이 객관식 답변일 경우, 선택지도 업데이트
    if (questionType == '객관식 답변') {
      selectedQuestion.choices = choiceControllers.map((controller) => controller.text).toList();
    }
    // 변경 사항 알리기
    notifyListeners();
  }

  void deleteQuestion(int index) {
    questions.removeAt(index);
    notifyListeners();
  }

  void changeQuestionType(String newValue) {
    questionType = newValue;
    notifyListeners();
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems() {
    return questionTypes.map((type) {
      return DropdownMenuItem<String>(
        value: type,
        child: Text(
          type,
        ),
      );
    }).toList();
  }

  Widget buildChoiceFields(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 150), // 최대 높이를 150으로 설정
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(), // 변경: 스크롤 가능하도록 설정
        itemCount: choiceControllers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0), // 변경: 세로 패딩 줄임
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: choiceControllers[index],
                    decoration: InputDecoration(
                      labelText: ' 문항 ${index + 1}',
                      border: OutlineInputBorder(),
                      hintText: ' 문항${index + 1}을 입력하세요 ',
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0), // Adjusting content padding
                    ),
                    style: TextStyle(fontSize: 16.0), // 변경: 폰트 크기 작게 조정
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    deleteChoiceController(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
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
        padding: const EdgeInsets.all(4.0),
        child: Consumer<SurveyProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color(0xFFD9EEF1),
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: provider.titleController,
                        decoration: InputDecoration(
                          labelText: ' 설문 제목',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 4.0), // Adjusting content padding
                        ),
                        style: TextStyle(fontSize: 16.0), // 폰트 크기 작게 조정
                        maxLines: 1,
                      ),
                      SizedBox(height: 4.0), // 변경: 위젯 간격 줄임
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0), // 변경: 패딩 적용
                        child: TextField(
                          controller: provider.questionController,
                          decoration: InputDecoration(
                            labelText: ' 질문',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 4.0), // Adjusting content padding
                          ),
                          style: TextStyle(fontSize: 16.0), // 폰트 크기 작게 조정
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 4.0), // 변경: 위젯 간격 줄임
                      Row(
                        children: [
                          Text('필수 질문'),
                          SizedBox(width: 8), // Add some space between the text and the switch
                          Transform.scale(
                            scale: 0.8, // Reduce the size of the switch
                            child: Switch(
                              value: provider.isRequired,
                              onChanged: (value) {
                                provider.isRequired = value;
                                provider.notifyListeners(); // 변경사항 알림
                              },
                              activeColor: Color(0xFF48B5BB), // Change the color of the switch
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0), // 변경: 위젯 간격 줄임
                      if (provider.questionType == '객관식 답변')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('문항:'),
                            SizedBox(height: 8.0), // 변경: 위젯 간격 줄임
                            provider.buildChoiceFields(context),
                            SizedBox(height: 8.0), // 변경: 위젯 간격 줄임
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    provider.addChoiceController(context); // 포커스 관련 메서드 호출 시 context 전달
                                  },
                                  child: Text(
                                    '문항 추가',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF48B5BB)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      SizedBox(height: 8.0), // 변경: 위젯 간격 줄임
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                provider.addQuestion();
                              },
                              child: Text(
                                '질문 추가',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF48B5BB)),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          DropdownButton<String>(
                            value: provider.questionType,
                            onChanged: (newValue) {
                              provider.changeQuestionType(newValue!);
                            },
                            items: provider.buildDropdownMenuItems(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.0), // 변경: 위젯 간격 줄임
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false, // 변경: 스크롤 가능하도록 설정
                    itemCount: provider.questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Question ${index + 1}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '질문: ${provider.questions[index].text}',
                            ),
                            Text(
                              '유형: ${provider.questions[index].type}',
                            ),
                            if (provider.questions[index].choices != null &&
                                provider.questions[index].type == '객관식 답변')
                              Text(
                                'Choices: ${provider.questions[index].choices!.join(", ")}',
                              ),
                            Text( // 추가: 필수 여부 표시
                              '필수여부: ${provider.questions[index].isRequired ? "필수" : ""}',
                            ),
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
                SizedBox(height: 12.0), // 변경: 위젯 간격 줄임
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '설문 만들기 완료',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF48B5BB)),
                    ),
                  ),
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
  String type;
  List<String>? choices;
  bool isRequired; // 추가: 필수 여부

  Question({required this.text, required this.type, this.choices, required this.isRequired});
}

const List<String> questionTypes = ['서술형 답변', '객관식 답변'];
