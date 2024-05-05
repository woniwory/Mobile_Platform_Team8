import 'package:flutter/material.dart';

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
  final List<List<int>> _containerCounts = [
    [3],
    [8],
    [4]
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  '설문 제목 ${index + 1}',
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
