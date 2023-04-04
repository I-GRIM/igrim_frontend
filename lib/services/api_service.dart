import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:igrim/models/story_model.dart';

class ApiService {
  // 요청 url
  static const String baseURL = "";
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
