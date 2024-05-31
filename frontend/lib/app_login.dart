import 'package:flutter/material.dart';
import 'package:project_team8/app_main.dart';
import 'package:project_team8/create_user2.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project_team8/login_platform.dart';
import 'package:url_strategy/url_strategy.dart';

class Login {
  final String? userEmail;
  final String? userPassword;

  Login({
    this.userEmail,
    this.userPassword,
  });

  // Login 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      "userEmail": userEmail,
      "userPassword": userPassword,
    };
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'c62390a0a0aa054d39932a799620902d',
    javaScriptAppKey: '2aac375b171401d7a6db18aeae10e7eb',
  );
  setPathUrlStrategy();
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
      routes: {
        '/app': (context) => MyApp(), // '/app' 경로에 대한 위젯 설정
        '/create': (context) => CreateUser(), // '/create' 경로에 대한 위젯 설정
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);

      print(profileInfo.toString());

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

      // 카카오 로그인 성공 시 MyApp으로 이동
      Navigator.of(context).pushReplacementNamed('/app');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  void _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // 사용자에게 이메일과 비밀번호를 입력하라고 알림
      print(1);
      return;
    }

    Login login = Login(userEmail: email, userPassword: password);

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/users/login'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(login.toJson()),
    );

    if (response.statusCode == 200) {
      // 로그인 성공 시 MyApp으로 이동
      Navigator.of(context).pushReplacementNamed('/app');
    } else {
      // 로그인 실패 시 오류 메시지 표시
      print('로그인 실패: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFD9EEF1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 270,
                height: 230,
                child: Image.asset(
                  'assets/images/dku-logo.png', // 이미지 경로에 따라 수정해주세요
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 75.0),
              SizedBox(
                width: 500,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '사용자 아이디',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20.0), // 조금 간격 추가
              SizedBox(
                width: 500,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _login, // 로그인 버튼 눌릴 때 _login 함수 호출
                    child: Text('로그인'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF48B5BB)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      minimumSize: MaterialStateProperty.all(Size(130, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: signInWithKakao,
                    child: Text('카카오 로그인'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFE812)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      minimumSize: MaterialStateProperty.all(Size(130, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // 버튼과 회원가입 버튼 사이 간격 추가
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/create');
                },
                child: Text('회원가입'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF48B5BB)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  minimumSize: MaterialStateProperty.all(Size(130, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
