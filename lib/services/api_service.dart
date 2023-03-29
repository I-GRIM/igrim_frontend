import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:igrim/models/tale_model.dart';

class ApiService {
  // 요청 url
  static const String baseURL = "";
  // 추천수 순 동화 받아오기
  static Future<List<TaleModel>> getTaleLikedOrder() async {
    List<TaleModel> taleInstances = [];
    final url = Uri.parse('$baseURL/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        taleInstances.add(TaleModel.fromJson(webtoon));
      }
      return taleInstances;
    }
    throw Error();
  }
}
