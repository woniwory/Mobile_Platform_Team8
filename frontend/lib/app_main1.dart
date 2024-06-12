import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; // for json decoding
import 'package:http/http.dart' as http;
import 'package:project_team8/answer_survey.dart';
import 'package:project_team8/survey_clicked.dart';
import 'create_survey1.dart';
import 'app_login.dart'; // Import the app_login.dart file
import 'update_user.dart'; // Import the update_user.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)?.settings.arguments as int;
    return MaterialApp(
      home: SwipeDemo(userId: userId),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFD9EEF1),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF48B5BB),
        ),
      ),
      routes: {
        '/login': (context) => LoginPage(), // Define the route for login page
        '/update': (context) => UpdateUser(), // Define the route for update user page
        '/answer': (context) => AnswerSurvey(), // Define the route for answer survey page
        '/survey' : (context) => SurveyApp(),
      },
    );
  }
}

class SwipeDemo extends StatefulWidget {
  final int userId;

  SwipeDemo({required this.userId});

  @override
  _SwipeDemoState createState() => _SwipeDemoState();
}

class _SwipeDemoState extends State<SwipeDemo> {
  late PageController _controller;
  late List<Map<String, dynamic>> _surveyData = [];
  late List<Map<String, dynamic>> _filteredSurveyData = [];
  bool _isLoading = true;
  String? _error;
  int _selectedGroupIndex = 0;
  List<Map<String, dynamic>> _groups = [];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _fetchData(widget.userId);
    _controller.addListener(() {
      setState(() {
        _selectedGroupIndex = _controller.page!.round();
        _filterSurveysByGroup(_selectedGroupIndex);
      });
    });
  }

  Future<void> _fetchData(int userId) async {
    final url = 'http://localhost:8080/api/user-groups/user/$userId';
    print(userId);
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _surveyData = data.map((item) => item as Map<String, dynamic>).toList();
          _groups = _surveyData.map((item) => item['group'] as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = '데이터를 불러오는데 실패했습니다: 상태 코드 ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = '데이터를 불러오는데 오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

  void _filterSurveysByGroup(int groupIndex) {
    final groupId = _groups[groupIndex]['groupId'];
    setState(() {
      _filteredSurveyData = _surveyData.where((survey) => survey['group']['groupId'] == groupId).toList();
    });
  }

  // void _editGroupName(int groupIndex, String newGroupName) {
  //   setState(() {
  //     _groups[groupIndex]['groupName'] = newGroupName;
  //   });
  // }
  Future<void> updateGroupName(int groupId, String newGroupName) async {
    final url = 'http://localhost:8080/api/user-groups/$groupId';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'groupName': newGroupName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update group name');
    }
  }


  void _deleteGroup(int groupIndex) {
    setState(() {
      if (_groups.length > 1) {
        _groups.removeAt(groupIndex);
        _selectedGroupIndex = _selectedGroupIndex % _groups.length;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('그룹 삭제'),
            content: Text('최소 한 개의 그룹이 있어야 합니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
              ),
            ],
          ),
        );
      }
      _filterSurveysByGroup(_selectedGroupIndex);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEditGroupDialog(int groupIndex) {
    final TextEditingController groupNameController = TextEditingController();
    groupNameController.text = _groups[groupIndex]['groupName'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFB2DFE6),
          title: Text('그룹 이름 수정'),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(hintText: '그룹 이름 입력'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final groupName = groupNameController.text.trim();
                if (groupName.isNotEmpty) {
                  try {
                    await updateGroupName(_groups[groupIndex]['groupId'], groupName);
                    print(groupName);
                    print(groupIndex);
                    updateGroupName(groupIndex, groupName);
                    Navigator.of(context).pop();
                  } catch (e) {
                    // 그룹 이름 수정 실패 시 에러 처리
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('수정 실패'),
                          content: Text('그룹 이름 수정에 실패했습니다. 다시 시도해주세요.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }


  void _addGroup(String newGroupName) {
    setState(() {
      final newGroup = {
        'groupId': _groups.length + 1,
        'groupName': newGroupName,
      };
      _groups.add(newGroup);
      _selectedGroupIndex = _groups.length - 1;
      _filterSurveysByGroup(_selectedGroupIndex);
    });
  }
  void _deleteSurvey(int index) {
    final surveyId = _filteredSurveyData[index]['survey']['surveyId'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFB2DFE6),
          title: Text('설문 삭제'),
          content: Text('선택한 설문을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () async {
                final url = 'http://localhost:8080/api/user-groups/user/1/survey/$surveyId';
                try {
                  final response = await http.delete(Uri.parse(url));
                  if (response.statusCode == 204) {
                    // 삭제 성공
                    setState(() {
                      _filteredSurveyData.removeAt(index);
                    });
                    Navigator.pop(context); // 다이얼로그 닫기
                  } else {
                    // 삭제 실패
                    Navigator.pop(context); // 다이얼로그 닫기
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('설문 삭제 실패'),
                          content: Text('설문 삭제에 실패했습니다. 잠시 후 다시 시도해주세요.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // 실패 다이얼로그 닫기
                              },
                              child: Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  // 삭제 실패
                  Navigator.pop(context); // 다이얼로그 닫기
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('설문 삭제 실패'),
                        content: Text('설문 삭제 중 오류가 발생했습니다: $e'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // 실패 다이얼로그 닫기
                            },
                            child: Text('확인'),
                          ),                        ],
                      );
                    },
                  );
                }
              },
              child: Text('삭제', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: Text('취소', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // Dropdown menu for logout and profile edit
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Logout logic
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('로그아웃'),
                              content: Text('로그아웃 하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Perform logout action here
                                    Navigator.pop(context); // Close confirmation dialog
                                    Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login page
                                  },
                                  child: Text('로그아웃'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close confirmation dialog
                                  },
                                  child: Text('취소'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('로그아웃'),
                      ),
                      TextButton(
                        onPressed: () {
                          final userId = widget.userId;
                          // Profile edit logic
                          Navigator.of(context).pushNamed('/update', arguments: userId); // Navigate to update user page
                        },
                        child: Text('회원정보 수정'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/dku-logo.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Text(
                  '정성원님, 환영합니다 !',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : Padding(
            padding: EdgeInsets.only(top: 70),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  if (_controller.page! > 0) {
                    _controller.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                } else {
                  if (_controller.page! < _groups.length - 1) {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                '그룹: ${_groups[index]['groupName']}',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  final userId = widget.userId; // Fetch the userId from widget
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => SurveyApp(userId: userId)),
                                  // );
                                  Navigator.of(context).pushReplacementNamed('/survey', arguments: userId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showEditGroupDialog(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteGroup(index);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: _buildPageContainer(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFB2DFE6),
        onPressed: _showAddGroupDialog,
        child: Icon(Icons.group_add),
        tooltip: '그룹 추가',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPageContainer() {
    Color backgroundColor = Color(0xFFB2DFE6);

    return Container(
      color: backgroundColor,
      child: ListView.builder(
        itemCount: _filteredSurveyData.length,
        itemBuilder: (context, containerIndex) {
          return _buildContainerItem(containerIndex);
        },
      ),
    );
  }

  Widget _buildContainerItem(int index) {
    Color containerColor = Colors.white;

    return GestureDetector(
      onTap: () {
        print('설문 ${index + 1} 선택됨');
        // Fetch survey details and navigate to answer survey page
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => AnswerSurvey(questionId: _filteredSurveyData[index]['survey']['questionId']),
        //   ),
        // );
        final surveyId = _filteredSurveyData[index]['survey']['surveyId'];
        final userId = _filteredSurveyData[index]['user']['userId'];
        print(_filteredSurveyData[index]);
        print(surveyId);
        Navigator.of(context).pushReplacementNamed(
          '/answer',
          arguments: {'userId': userId, 'surveyId': surveyId},
        );
      },
      key: ValueKey('container_$index'),
      child: Container(
        width: double.infinity,
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  _filteredSurveyData[index]['survey']['surveyTitle'],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFFB2DFE6),
                      title: Text('설문 공유'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Copy link logic
                              final surveyId = _filteredSurveyData[index]['survey']['surveyId'];
                              final surveyUrl = 'http://exampleurl.com/surveys/$surveyId';
                              // Copy to clipboard logic
                              Clipboard.setData(ClipboardData(text: surveyUrl));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('설문 링크가 복사되었습니다.'),
                                ),
                              );
                            },
                            // Copy link logic
                            child: Text('링크 복사하기', style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: () {
                              // Share via KakaoTalk logic
                            },
                            child: Text('카카오톡으로 공유하기', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.poll),
              onPressed: () {
                print('설문 ${index + 1} 결과 조회 버튼 클릭됨');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClickedApp()),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 30),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  print('설문 ${index + 1} 삭제 버튼 클릭됨');
                  _deleteSurvey(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGroupDialog() {
    final TextEditingController groupNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFB2DFE6),
          title: Text('새 그룹 추가'),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(hintText: '그룹 이름 입력'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final groupName = groupNameController.text.trim();
                if (groupName.isNotEmpty) {
                  _addGroup(groupName);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF48B5BB), // 버튼 배경색
              ),
              child: Text('추가', style: TextStyle(color: Colors.black)),
            ),

          ],
        );
      },
    );
  }
}
