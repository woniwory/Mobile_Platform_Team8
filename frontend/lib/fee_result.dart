import 'dart:convert'; // Add this import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart'; // URL launcher 패키지 임포트

class UserSurvey {
  final int userSurveyId;
  final User user;
  final Survey survey;
  final bool feeStatus;
  final bool admin;

  UserSurvey({
    required this.userSurveyId,
    required this.user,
    required this.survey,
    required this.feeStatus,
    required this.admin,
  });

  factory UserSurvey.fromJson(Map<String, dynamic> json) {
    return UserSurvey(
      userSurveyId: json['userSurveyId'],
      user: User.fromJson(json['user']),
      survey: Survey.fromJson(json['survey']),
      feeStatus: json['feeStatus'],
      admin: json['admin'],
    );
  }
}

class User {
  final int userId;
  final String userName;
  final String userEmail;
  final String userPassword;


  User({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      userPassword: json['userPassword'],
    );
  }
}

class Survey {
  final int surveyId;
  final String surveyTitle;
  final String surveyDescription;
  final DateTime surveyStartDate;
  final DateTime surveyEndDate;
  final int participants;
  final int requiredPayment;

  Survey({
    required this.surveyId,
    required this.surveyTitle,
    required this.surveyDescription,
    required this.surveyStartDate,
    required this.surveyEndDate,
    required this.participants,
    required this.requiredPayment,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      surveyId: json['surveyId'],
      surveyTitle: json['surveyTitle'],
      surveyDescription: json['surveyDescription'],
      surveyStartDate: DateTime.parse(json['surveyStartDate']),
      surveyEndDate: DateTime.parse(json['surveyEndDate']),
      participants: json['participants'],
      requiredPayment: json['requiredPayment'] ?? 0,
    );
  }
}

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

class PaymentStatusBody extends StatefulWidget {
  @override
  _PaymentStatusBodyState createState() => _PaymentStatusBodyState();
}

class _PaymentStatusBodyState extends State<PaymentStatusBody> {
  Future<UserSurvey>? _userSurveyFuture;

  @override
  void initState() {
    super.initState();
    _userSurveyFuture = fetchUserSurvey();
  }

  Future<UserSurvey> fetchUserSurvey() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/user-surveys/1'));

    if (response.statusCode == 200) {
      return UserSurvey.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user survey');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSurvey>(
      future: _userSurveyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final userSurvey = snapshot.data!;
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
                      userSurvey.survey.surveyTitle,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      userSurvey.survey.surveyDescription,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "총 참여자 수: ${userSurvey.survey.participants}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "요구 금액: ${userSurvey.survey.requiredPayment}원", // Adjust this field as needed
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              // 사용자 납부 현황 리스트뷰
              Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return PaymentItem(
                      name: userSurvey.user.userName,
                      paid: userSurvey.feeStatus,
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

class PaymentItem extends StatefulWidget {
  final String name;
  bool paid; // Make this mutable to allow updates

  PaymentItem({required this.name, required this.paid});

  @override
  _PaymentItemState createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  bool _isSentSuccessful = false;

  Future<void> _fetchFeeStatus() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/user-surveys/fee-status/1/2'));

    if (response.statusCode == 200) {
      final feeStatus = json.decode(response.body);
      setState(() {
        widget.paid = feeStatus;
      });
    } else {
      throw Exception('Failed to fetch fee status');
    }
  }

  Future<void> _updateFeeStatus() async {

    final response = await http.put(Uri.parse('http://localhost:8080/api/user-surveys/user/1/survey/2'));


    if (response.statusCode == 200) {
      print("updated feestatus");
      await _fetchFeeStatus(); // 송금 완료 후 fee status 가져오기
    } else {
      throw Exception('Failed to update fee status');
    }
  }

  void _showJsonOutput() {
    setState(() {
      _isSentSuccessful = true;
    });

    final jsonData = {
      'name': widget.name,
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
              Spacer(), // Add a spacer to push the button to the right
              ElevatedButton(
                onPressed: _isSentSuccessful
                    ? null
                    : () async {
                  await launchUrlString('https://link.kakaopay.com/_/I8915sY');
                  await _updateFeeStatus(); // Call _updateFeeStatus when button is pressed
                  _showJsonOutput();
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
        ],
      ),
    );
  }
}
