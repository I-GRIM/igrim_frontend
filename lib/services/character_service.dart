import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:igrim/dtos/make_new_character_req_dto.dart';
import 'package:igrim/dtos/make_new_character_res_dto.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/exceptions/error_code.dart';
import 'package:http_parser/http_parser.dart';
import 'package:igrim/services/jwt_service.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;
import 'package:igrim/api_keys.dart';

class CharacterService {
  // 요청 url
  static const String baseURL = "http://$BACKEND_URL/api/character";
  // 추천수 순 동화 받아오기

  static Future<MakeNewCharacterResDto> makeNewCharacter(
      MakeNewCharacterReqDto makeNewCharacterReqDto, String imagePath) async {
    final url = Uri.parse(baseURL);
    var request = http.MultipartRequest('POST', url)
      ..fields['value'] = makeNewCharacterReqDto.toString()
      ..headers['Authorization'] = 'Bearer ${await JwtService.getJwt()}'
      ..headers['Content-Type'] = "multipart/form-data";
    developer.log(request.toString(), name: "CharacterService");

    File image = File(imagePath);
    request.files.add(http.MultipartFile(
        'charac', image.readAsBytes().asStream(), image.lengthSync(),
        filename: basename(image.path),
        contentType: MediaType('multipart', 'form-data')));
    var response = await request.send(); //
    var responsed = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      developer.log(responsed.body.toString(), name: "CharacterService");
      return MakeNewCharacterResDto(responsed.body);
    } else {
      developer.log(responsed.body.toString(), name: "CharacterService");
      throw BaseException(ErrorCode.NEED_SIGN_IN, "에러 메세지");
    }
  }
}
