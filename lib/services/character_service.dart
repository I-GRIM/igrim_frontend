import 'dart:convert';
import 'package:igrim/dtos/make_new_character_req_dto.dart';
import 'package:igrim/dtos/make_new_character_res_dto.dart';
import 'package:igrim/api_keys.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/exceptions/error_code.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:http_parser/http_parser.dart';
import 'package:igrim/services/jwt_service.dart';

class CharacterService {
  // 요청 url
  static const String baseURL = "http://$BACKEND_URL/api/character";
  // 추천수 순 동화 받아오기

  static Future<MakeNewCharacterResDto> makeNewCharacter(
    MakeNewCharacterReqDto makeNewCharacterReqDto,
    String imagePath,
  ) async {
    var headers = {'Authorization': 'Bearer ${await JwtService.getJwt()}'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://$BACKEND_URL:8080/api/character'));
    //request.fields.addAll({'value': '{"name" : "${makeNewCharacterReqDto.name}"}'});
    request.files.add(
      http.MultipartFile.fromBytes(
        'value',
        utf8.encode(json.encode({"name": makeNewCharacterReqDto.name})),
        contentType: MediaType(
          'application',
          'json',
          {'charset': 'utf-8'},
        ),
      ),
    );
    request.files.add(await http.MultipartFile.fromPath('charac', imagePath));
    request.headers.addAll(headers);
    developer.log("send requiest", name: "createCharacter");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      String res = await response.stream.bytesToString();
      developer.log(res, name: "reponse");
      return MakeNewCharacterResDto.fromJson(json.decode(res));
    } else {
      developer.log(await response.stream.bytesToString());
      throw BaseException(ErrorCode.NEED_SIGN_IN, "오류");
    }
  }
}
