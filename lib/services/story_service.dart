import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:igrim/api_keys.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:igrim/dtos/get_all_story_res_dto.dart';
import 'package:igrim/dtos/get_story_by_id_res_dto.dart';
import 'package:igrim/dtos/page_create_req_dto.dart';
import 'package:http_parser/http_parser.dart';
import 'package:igrim/dtos/page_create_res_dto.dart';

import 'package:igrim/dtos/story_create_req_dto.dart';
import 'package:igrim/dtos/story_create_res_dto.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/exceptions/error_code.dart';
import 'package:igrim/models/character_model.dart';
import 'package:igrim/services/device_service.dart';
import 'package:igrim/services/jwt_service.dart';
import 'package:path_provider/path_provider.dart';

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

  static Future<PageCreateResDto> createPage(
      String storyId, PageCreateReqDto pageCreateReqDto) async {
    List<CharacterModel> characters = await DeviceService.getCharacters();
    final url = Uri.parse("$baseURL/$storyId");
    var headers = {'Authorization': 'Bearer ${await JwtService.getJwt()}'};
    var request = http.MultipartRequest('POST', Uri.parse("$baseURL/$storyId"));
    developer.log(pageCreateReqDto.x.toString(), name: "x");
    developer.log(pageCreateReqDto.y.toString(), name: "y");
    developer.log(pageCreateReqDto.characterPrompt.toString(), name: "prompt");
    //request.fields.addAll({'value': '{"name" : "${makeNewCharacterReqDto.name}"}'});
    request.files.add(
      http.MultipartFile.fromBytes(
        'value',
        utf8.encode(pageCreateReqDto.toJson()),
        contentType: MediaType(
          'application',
          'json',
          {'charset': 'utf-8'},
        ),
      ),
    );

    final http.Response backgroundRes =
        await http.get(Uri.parse(pageCreateReqDto.imgUrl));
    Uint8List uint8list = backgroundRes.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/img').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    request.files
        .add(await http.MultipartFile.fromPath('background', file.path));
    request.files.add(await http.MultipartFile.fromPath(
      'character',
      characters[0].image.path,
    ));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    developer.log(response.statusCode.toString(), name: "reponse");

    if (response.statusCode == 201) {
      String res = await response.stream.bytesToString();
      var dict = json.decode(res);
      developer.log(response.statusCode.toString(), name: "reponse");
      return PageCreateResDto.fromJson(dict);
    } else {
      developer.log(await response.stream.bytesToString());
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
      if (temp.isEmpty) {
        return [];
      }
      developer.log(temp[0].toString(), name: "list");
      List<GetStoryByIdResDto> pageList = [];
      for (var element in temp) {
        developer.log(element.toString(), name: "storysrvice element");
        pageList.add(GetStoryByIdResDto.fromJson(element));
      }
      return pageList;
    } else {
      developer.log(response.body.toString(), name: "StoryService");
      throw BaseException(ErrorCode.NEED_SIGN_IN, "오류");
    }
  }
}
