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
  final PageController _controller = PageController(initialPage: 0);
  final List<List<int>> _containerCounts = [
    [3],
    [8],
    [4]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 70),
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
            } else {
              _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
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
                              // 아이콘을 누르면 추가 작업을 수행합니다.
                              print('Add button clicked for 모임 ${pageIndex + 1}');
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
      child: PageView.builder(
        itemCount: _containerCounts[pageIndex].length,
        itemBuilder: (context, containerIndex) {
          return _buildContainerList(_containerCounts[pageIndex][containerIndex]);
        },
      ),
    );
  }

  Widget _buildContainerList(int count) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        Color containerColor = Colors.white;

        return GestureDetector(
          onTap: () {
            print('Container ${index + 1} clicked');
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.05,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('Container ${index + 1}', style: TextStyle(fontSize: 18)),
            ),
          ),
        );
      },
    );
  }
}