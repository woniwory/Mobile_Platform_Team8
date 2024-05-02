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
  String questionType = 'Open Ended'; // 수정: 기본값을 Open Ended로 변경
  String selectedChoice = 'Add Choice';
  bool showChoicesDropdown = false;

  void addQuestion() {
    if (questionType == 'Multiple Choice') {
      List<String> choices = [];
      for (var controller in choiceControllers) {
        choices.add(controller.text);
      }
      questions.add(
        Question(
          text: questionController.text,
          type: questionType,
          choices: choices,
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
        ),
      );
    }
    questionController.clear();
    notifyListeners();
  }

  void addChoiceController() {
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

    // 질문의 타입이 Multiple Choice인 경우
    if (questionType == 'Multiple Choice') {
      // 기존의 선택한 질문의 선택지를 가져와서 choiceControllers에 추가
      choiceControllers.clear(); // 선택한 질문을 수정할 때마다 choiceControllers를 비워줌
      selectedQuestion.choices?.forEach((choice) {
        choiceControllers.add(TextEditingController(text: choice));
      });
    } else {
      // Multiple Choice가 아닌 경우에는 choiceControllers를 비움
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
    // 선택한 질문이 Multiple Choice일 경우, 선택지도 업데이트
    if (questionType == 'Multiple Choice') {
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

  List<Widget> buildChoiceFields() {
    List<Widget> choiceFields = [];
    for (int i = 0; i < choiceControllers.length; i++) {
      choiceFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: choiceControllers[i],
                  decoration: InputDecoration(
                    labelText: 'Choice ${i + 1}',
                    border: OutlineInputBorder(),
                    hintText: 'Enter choice ${i + 1}',
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  deleteChoiceController(i);
                },
              ),
            ],
          ),
        ),
      );
    }
    return choiceFields;
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
                Container(
                  color: Color(0xFFD9EEF1),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: provider.titleController,
                        decoration: InputDecoration(
                          labelText: 'Survey Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: provider.questionController,
                        decoration: InputDecoration(
                          labelText: 'Enter your question',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      if (provider.questionType == 'Multiple Choice')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Choices:'),
                            Column(
                              children: provider.buildChoiceFields(),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    provider.addChoiceController();
                                  },
                                  child: Text(
                                    'Add Choice',
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
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // provider.addQuestion();
                                provider.addQuestion(); // 질문 추가 버튼 눌렀을 때 기존 질문을 추가
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
                SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
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
                              'Text: ${provider.questions[index].text}',
                            ),
                            Text(
                              'Type: ${provider.questions[index].type}',
                            ),
                            if (provider.questions[index].choices != null &&
                                provider.questions[index].type == 'Multiple Choice')
                              Text(
                                'Choices: ${provider.questions[index].choices!.join(", ")}',
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
                                provider.saveEditedQuestion(index); // 질문 수정 버튼 눌렀을 때 선택된 질문을 수정
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {}, // 아직 미구현
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

  Question({required this.text, required this.type, List<String>? choices})
      : choices = choices ?? [];
}

const List<String> questionTypes = ['Open Ended', 'Multiple Choice'];
