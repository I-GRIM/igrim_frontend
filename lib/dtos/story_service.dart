import 'dart:convert';

import 'package:igrim/api_keys.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:igrim/dtos/get_all_story_res_dto.dart';
import 'package:igrim/dtos/get_story_by_id_res_dto.dart';
import 'package:igrim/dtos/page_create_req_dto.dart';

import 'package:igrim/dtos/story_create_req_dto.dart';
import 'package:igrim/dtos/story_create_res_dto.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/exceptions/error_code.dart';
import 'package:igrim/services/jwt_service.dart';

void main() async {}

class StoryService {
  static const String baseURL = "http://$BACKEND_URL:8080/api/story";

  static Future<List<GetAllStoryResDto>> getAllStory() async {
    final url = Uri.parse(baseURL);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await JwtService.getJwt()}'
      },
    );

    if (response.statusCode == 200) {
      developer.log(response.body, name: "story_service");
      List<dynamic> a = json.decode(utf8.decode(response.bodyBytes));
      List<GetAllStoryResDto> storyList = [];
      for (var element in a) {
        storyList.add(GetAllStoryResDto.fromJson(element));
      }
      return storyList;
    } else {
      developer.log(response.body, name: "StoryService");
      throw BaseException(ErrorCode.NEED_SIGN_IN, "getAllStoryError");
    }
  }

  static Future<StoryCreateResDto> createStory(
      StoryCreateReqDto storyCreateReqDto) async {
    final url = Uri.parse(baseURL);
    developer.log("$url", name: "StoryService");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await JwtService.getJwt()}'
      },
      body: storyCreateReqDto.toJson(),
    );
    developer.log(response.body, name: "StoryService");
    if (response.statusCode == 201) {
      return StoryCreateResDto.fromJson(json.decode(response.body));
    } else {
      developer.log(response.statusCode.toString(), name: "LoginAPI");
      developer.log(response.body.toString());
      throw BaseException(ErrorCode.NEED_SIGN_IN, "오류");
    }
  }

  static Future<String> createPage(
      String storyId, PageCreateReqDto pageCreateReqDto) async {
    final url = Uri.parse("$baseURL/$storyId");
    developer.log("$url", name: "StoryService");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await JwtService.getJwt()}'
      },
      body: pageCreateReqDto.toJson(),
    );
    developer.log(response.body, name: "StoryService");
    if (response.statusCode == 200) {
      return "ok";
    } else {
      developer.log(response.statusCode.toString(), name: "LoginAPI");
      throw BaseException(ErrorCode.NEED_SIGN_IN, "오류");
    }
  }

  static Future<List<GetStoryByIdResDto>> getStoryById(String storyId) async {
    final url = Uri.parse("$baseURL/$storyId");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await JwtService.getJwt()}'
      },
    );
    developer.log(response.body, name: "StoryService");
    if (response.statusCode == 200) {
      List<dynamic> temp = json.decode(utf8.decode(response.bodyBytes));
      List<GetStoryByIdResDto> pages = [];
      for (var element in temp) {
        pages.add(GetStoryByIdResDto.fromJson(element));
      }
      return pages;
    } else {
      developer.log(response.statusCode.toString(), name: "LoginAPI");
      throw BaseException(ErrorCode.NEED_SIGN_IN, "오류");
    }
  }
}
