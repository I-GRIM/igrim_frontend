import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:igrim/dtos/login_req_dto.dart';
import 'package:igrim/dtos/login_res_dto.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/exceptions/error_code.dart';
import 'package:igrim/api_keys.dart';
import 'package:igrim/models/story_model.dart';
import 'dart:developer' as developer;

class AuthService {
  // 요청 url
  static const String baseURL = "http://$BACKEND_URL/api/auth";

  static Future<LoginResDto> userLogin(LoginReqDto loginReqDto) async {
    //api
    final url = Uri.parse('$baseURL/sign-in');
    developer.log("$url", name: "LoginAPI");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: loginReqDto.toJson(),
    );
    developer.log(response.body, name: "AuthService");

    if (response.statusCode == 200) {
      return LoginResDto.fromJson(json.decode(response.body));
    } else {
      developer.log(response.statusCode.toString(), name: "LoginAPI");
      throw BaseException(ErrorCode.NEED_SIGN_IN, "오류");
    }
  }

  // 추천수 순 동화 받아오기
  static Future<List<StoryModel>> getTaleLikedOrder() async {
    List<StoryModel> taleInstances = [];
    final url = Uri.parse('$baseURL/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return taleInstances;
    }
    throw Error();
  }
}
