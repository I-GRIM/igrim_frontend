import 'package:http/http.dart' as http;
import 'package:igrim/dtos/base_header.dart';
import 'package:igrim/dtos/make_new_character_req_dto.dart';

class CharacterService {
  // 요청 url
  static const String baseURL = "/character";

  // 추천수 순 동화 받아오기
  static Future<String> makeNewCharacters(
      MakeNewCharacterReqDto makeNewCharacterReqDto) async {
    final url = Uri.parse('$baseURL/info');
    final response = await http.post(
      url,
      headers: BaseHeader().toJson(),
      body: makeNewCharacterReqDto,
    );
    if (response.statusCode == 200) {
      return '성공';
    } else {
      throw Error();
    }
  }
}
