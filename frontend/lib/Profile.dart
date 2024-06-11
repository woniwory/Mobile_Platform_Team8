class Profile {
  final String? userAccountNumber;
  final String? userEmail;
  final String? userName;
  final String? userPassword;

  Profile({
    this.userAccountNumber,
    this.userEmail,
    this.userName,
    this.userPassword,
  });

  // Profile 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      "userAccountNumber": userAccountNumber,
      "userEmail": userEmail,
      "userName": userName,
      "userPassword": userPassword,
    };
  }
}