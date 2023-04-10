import 'dart:convert';

class LoginReqDto {
  String email, password, nickname;

  LoginReqDto(this.email, this.password, this.nickname);

  String toJson() => json.encode({
        'email': email,
        'password': password,
        'nickname': nickname,
      });

      @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
