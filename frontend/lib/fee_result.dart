import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert';

void main() {
  runApp(PaymentStatusPage());
}

class PaymentStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF48B5BB),
          title: Text(
            "납부 현황",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: PaymentStatusBody(),
        backgroundColor: Color(0xFFD9EEF1),
      ),
    );
  }
}

class PaymentStatusBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 모임 정보 (DB에서 받아옴)
    String groupName = "모임 이름";
    String surveyTitle = "설문 제목";
    int totalParticipants = 100; // 총 참여자 수
    int requiredAmount = 100000; // 요구 금액

    // 사용자 납부 현황 (DB에서 받아옴)
    List<Map<String, dynamic>> userPayments = [
      {"name": "정성원", "currentAmount": 50000, "paid": true},
      {"name": "이호영", "currentAmount": 30000, "paid": false},
      {"name": "박수현", "currentAmount": 120000, "paid": true},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 모임 정보와 요구 금액 컨테이너
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
              SizedBox(height: 8),
              Text(
                "요구 금액: ${requiredAmount.toString()}원",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        // 사용자 납부 현황 리스트뷰
        Expanded(
          child: ListView.builder(
            itemCount: userPayments.length,
            itemBuilder: (BuildContext context, int index) {
              return PaymentItem(
                name: userPayments[index]['name'],
                currentAmount: userPayments[index]['currentAmount'],
                paid: userPayments[index]['paid'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class PaymentItem extends StatefulWidget {
  final String name;
  final int currentAmount;
  final bool paid;

  PaymentItem({required this.name, required this.currentAmount, required this.paid});

  @override
  _PaymentItemState createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  bool _isSentSuccessful = false;

  void _showJsonOutput() {
    setState(() {
      _isSentSuccessful = true;
    });

    final jsonData = {
      'name': widget.name,
      'currentAmount': widget.currentAmount,
      'paid': widget.paid,
    };

    final jsonString = jsonEncode(jsonData);
    print('JSON Output: $jsonString');
  }

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
            "이름: ${widget.name}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "현재 납부 금액: ${widget.currentAmount.toString()}원",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "완납 여부: ",
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                widget.paid ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: widget.paid ? Colors.green : Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 20), // 버튼과 송금하기 버튼 사이의 간격 조절
          ElevatedButton(
            onPressed: _isSentSuccessful ? null : () {
              launchUrlString('https://link.kakaopay.com/_/I8915sY'); // 카카오페이 송금 링크로 이동
              _showJsonOutput(); // 송금 완료 후 JSON 출력
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color(0xff0165E1),
              ),
            ),
            child: Text(
              _isSentSuccessful ? '송금 완료' : '송금하기',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}