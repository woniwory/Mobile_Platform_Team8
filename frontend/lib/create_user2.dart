import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile.dart';

void main() {
  runApp(CreateUser());
}

class CreateUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Edit Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfileEditScreen(),
    );
  }
}



class ProfileEditScreen extends StatefulWidget {
  final Profile? profile;

  const ProfileEditScreen({Key? key, this.profile}) : super(key: key);

  @override
  ProfileEditScreenState createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _userAccountNumber = '234234234';
  String? _userEmail = 'psh911@naver.com';
  String? _userName = '박수현';
  String? _userPassword = '박수현Password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? "회원가입" : "회원정보 수정"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _userAccountNumber,
                decoration: const InputDecoration(labelText: "사용자 계좌번호"),
                onSaved: (value) => _userAccountNumber = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: _userEmail,
                decoration: const InputDecoration(labelText: "사용자 이메일"),
                onSaved: (value) => _userEmail = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  // 정규 표현식 사용해서 이메일 형식검증
                  String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return '유효한 이메일 주소를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: _userName,
                decoration: const InputDecoration(labelText: "사용자 이름"),
                onSaved: (value) => _userName = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: _userPassword,
                decoration: const InputDecoration(labelText: "사용자 비밀번호"),
                obscureText: true,
                onChanged: (value) => _userPassword = value,
                onSaved: (value) => _userPassword = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  if (value.length < 8) {
                    return "비밀번호는 최소 8자리여야 합니다";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _formkey.currentState!.save();

                    final newProfile = Profile(
                      userAccountNumber: _userAccountNumber,
                      userEmail: _userEmail,
                      userName: _userName,
                      userPassword: _userPassword,
                    );

                    // Profile 객체를 JSON으로 변환
                    final jsonData = newProfile.toJson();
                    // JSON 데이터를 문자열로 변환
                    final requestBody = json.encode(jsonData);

                    // 서버 주소
                    String url = 'http://localhost:8080/api/users';

                    // HTTP POST 요청 보내기
                    http.post(
                      Uri.parse(url),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: requestBody,
                    ).then((response) {
                      // 응답 확인
                      if (response.statusCode == 201) {
                        // 서버로부터 온 응답 데이터 출력
                        print('Response: ${response.body}');
                        // 성공 시 다음 화면으로 이동
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => NextPage()),
                        // );
                      } else {
                        // 에러 처리
                        print('Failed with status code: ${response.statusCode}');
                      }
                    }).catchError((error) {
                      print('Error: $error');
                    });
                  }
                },
                child: const Text("저장하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
