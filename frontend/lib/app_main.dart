import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SwipeDemo(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFD9EEF1),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF48B5BB),
        ),
      ),
    );
  }
}

class SwipeDemo extends StatefulWidget {
  @override
  _SwipeDemoState createState() => _SwipeDemoState();
}

class _SwipeDemoState extends State<SwipeDemo> {
  late PageController _controller;
  late List<List<int>> _containerCounts; // 그룹당 설문 개수를 저장할 리스트
  late List<List<String>> _surveyTitles; // 설문 제목을 저장할 리스트

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _loadData(); // 데이터 로드
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 데이터를 로드하는 메서드
  Future<void> _loadData() async {
    _containerCounts = [];
    _surveyTitles = [];
    // 그룹당 설문 개수 조회
    List<int> groupCounts = await _fetchGroupCounts();
    // 각 그룹에 대해 설문 제목 및 개수 조회
    for (int i = 0; i < groupCounts.length; i++) {
      // 그룹별 설문 개수 추가
      _containerCounts.add([groupCounts[i]]);
      // 그룹별 설문 제목 추가
      List<String> titles = [];
      for (int j = 0; j < groupCounts[i]; j++) {
        titles.add(await _fetchSurveyTitle(i, j));
      }
      _surveyTitles.add(titles);
    }
    setState(() {}); // 화면 갱신
  }

  Future<List<int>> _fetchGroupCounts() async {
    String apiUrl = 'http://localhost:8080/userGroups/1/survey-titles';
    try {
      http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);
        List<int> groupCounts = (responseData['group_counts'] as List<dynamic>).map<int>((count) => int.parse(count)).toList();
        return groupCounts;
      } else {
        throw Exception('그룹 개수를 불러오는데 실패했습니다');
      }
    } catch (e) {
      print('에러: $e');
      return [];
    }
  }


  // 그룹별 설문 제목을 조회하는 메서드
  Future<String> _fetchSurveyTitle(int groupIndex, int surveyIndex) async {
    // API 엔드포인트 설정
    String apiUrl = 'http://localhost:8080/userGroups/$groupIndex/survey-titles';
    try {
      // HTTP GET 요청 보내기
      http.Response response = await http.get(Uri.parse(apiUrl));
      // 응답 확인
      if (response.statusCode == 200) {
        // JSON 데이터 파싱
        dynamic data = json.decode(response.body);
        // 설문 제목 반환
        return data[surveyIndex]['surveyTitle'];
      } else {
        // 에러 처리
        throw Exception('설문 제목을 불러오는데 실패했습니다');
      }
    } catch (e) {
      print('에러: $e');
      return ''; // 에러 발생 시 빈 문자열 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 70),
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              if (_controller.page! > 0) {
                _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
              }
            } else {
              if (_controller.page! < _containerCounts.length - 1) {
                _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
              }
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.45,
            child: PageView.builder(
              controller: _controller,
              itemCount: _containerCounts.length,
              itemBuilder: (context, pageIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            '모임 ${pageIndex + 1}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              print('모임 ${pageIndex + 1}에 아이템 추가');
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: _buildPageContainer(pageIndex),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContainer(int pageIndex) {
    Color backgroundColor = Color(0xFFB2DFE6);

    return Container(
      color: backgroundColor,
      child: ListView.builder(
        itemCount: _containerCounts[pageIndex].length,
        itemBuilder: (context, containerIndex) {
          return _buildContainerList(pageIndex, containerIndex);
        },
      ),
    );
  }

  Widget _buildContainerList(int pageIndex, int containerIndex) {
    return ReorderableListView(
      padding: EdgeInsets.symmetric(vertical: 8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(
        _containerCounts[pageIndex][containerIndex],
            (index) => _buildContainerItem(pageIndex, containerIndex, index),
      ),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          // Adjust the lists according to the new order
          final List<int> list = _containerCounts[pageIndex];
          final item = list.removeAt(oldIndex);
          list.insert(newIndex, item);
        });
      },
    );
  }

  Widget _buildContainerItem(int pageIndex, int containerIndex, int index) {
    Color containerColor = Colors.white;

    return GestureDetector(
      onTap: () {
        print('컨테이너 ${index + 1} 선택됨');
      },
      key: ValueKey('container_${pageIndex}_${containerIndex}_${index}'),
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
            // ReorderableListView 아이콘 추가
            GestureDetector(
              onLongPress: () {
                // Do something when the ReorderableListView icon is pressed
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  _surveyTitles[pageIndex][containerIndex], // 설문 제목을 출력
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            // 아이콘들에 패딩 추가
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                print('컨테이너 ${index + 1} 공유 버튼 클릭됨');
              },
            ),
            IconButton(
              icon: Icon(Icons.poll),
              onPressed: () {
                print('컨테이너 ${index + 1} 결과 조회 버튼 클릭됨');
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 30),
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  print('컨테이너 ${index + 1} 설정 버튼 클릭됨');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
