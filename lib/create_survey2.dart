import "package:flutter/material.dart";
import "create_user1.dart";




class ProfileEditScreen extends StatefulWidget{
  final Profile? profile; // /? : Profile가 null이 될 수도 있다

  const ProfileEditScreen({super.key, this.profile});

  @override
  ProfileEditScreenState createState() => ProfileEditScreenState();

}

class ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _name; // 사용자 데이터 입력 받는 부분
  String? _email; // 사용자 데이터 입력 받는 부분
  String? _password; // 사용자 데이터 입력 받는 부분
  String? _confirm_password; // 사용자 데이터 입력 받는 부분
  String? _account; // 사용자 데이터 입력 받는 부분

  // widget 생명 주기에서 가장 먼저 수행
  void initState() {
    super.initState();
    if (widget.profile != null) {
      _name = widget.profile!.name;
      _email = widget.profile!.email;
      _password = widget.profile!.password;
      _confirm_password = widget.profile!.confirm_password;
      _account = widget.profile!.account;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10), // AppBar의 높이 조정
        child: AppBar(
          title: Text(widget.profile == null ? "회원가입" : "회원정보 수정",
            style: TextStyle(color: Colors.white),),
          backgroundColor: const Color(0xFF48B5BB),
        ),
      ),
      backgroundColor: const Color(0xFFD9EEF1),
      body: Padding(
        padding: const EdgeInsets.all(10), // 입력란 간격 조정
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: "사용자 이름"),
                onSaved: (value) => _name = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 50), // 간격 추가
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: "사용자 이메일"),
                onSaved: (value) => _email = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  // 정규 표현식 사용해서 이메일 형식검증,,
                  String pattern =
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return '유효한 이메일 주소를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50), // 간격 추가
              TextFormField(
                initialValue: _password,
                decoration: const InputDecoration(labelText: "사용자 비밀번호"),
                obscureText: true,
                onSaved: (value) => _password = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 50), // 간격 추가
              TextFormField(
                initialValue: _confirm_password,
                decoration: InputDecoration(labelText: "비밀번호 재확인"),
                obscureText: true,
                onSaved: (value) => _confirm_password = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  if (value != _password) {
                    return "비밀번호가 일치하지 않습니다";
                  }
                  return null;
                },
              ),
              SizedBox(height: 50), // 간격 추가
              TextFormField(
                initialValue: _account,
                decoration: const InputDecoration(labelText: "사용자 계좌정보"),
                onSaved: (value) => _account = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "내용을 입력하세요";
                  }
                  return null;
                },
              ),
              SizedBox(height: 200), // 간격 추가
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _formkey.currentState!.save();

                    final newProfile = Profile(
                      name: _name!,
                      email: _email!,
                      password: _password!,
                      confirm_password: _confirm_password!,
                      account: _account!,
                    );

                    Navigator.pop(context, newProfile);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF48B5BB)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // 텍스트 색상 검정색으로 변경
                  minimumSize: MaterialStateProperty.all(Size(75, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: const Text("저장하기"),
              ),


            ],
          ),
        ),
      ),
    );
  }
}