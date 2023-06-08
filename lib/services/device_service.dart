import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/exceptions/error_code.dart';
import 'package:igrim/models/character_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class DeviceService {
  static void clean() async {
    final bdirectory =
        Directory("${await getStoryMakingDirectory()}/characters");
    if (await bdirectory.exists()) {
      bdirectory.delete(recursive: true);
      developer.log("StoryMakingDirectoryDeleted", name: "DeviceService");
    }
  }

  static Future<String> getStoryMakingDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    developer.log(directory.list().toList().toString(), name: "DeviceService");
    return directory.path;
  }

  static Future<String> makeStoryMakingDirectory() async {
    final directory =
        Directory("${await getStoryMakingDirectory()}/characters");
    directory.create(); //create directory if doesn't exits
    return directory.path;
  }

  //static Future<bool> deleteStoryMakingDirectory() async {}
  static Future<List<CharacterModel>> getCharacters() async {
    final directory =
        Directory("${await getStoryMakingDirectory()}/characters");
    List<CharacterModel> characters = [];

    try {
      if (await directory.exists()) {
        //read
        directory.listSync().forEach((entity) async {
          developer.log("path : ${entity.path}", name: "DeviceService");

          if (entity is Directory) {
            final files = entity.listSync().whereType<File>();
            final img = files.firstWhere(
              (file) => file.path.endsWith("img.jpeg"),
              orElse: () => throw Exception('Image Not Found'),
            );
            final info = files.firstWhere(
              (file) => file.path.endsWith("info.json"),
              orElse: () => throw Exception('Info Not Found'),
            );

            final character = CharacterModel.fromJson(
                json.decode(await info.readAsString()), img);
            characters.add(character);
          } else {}
        });
      } else {
        //characters not created yet
      }
    } catch (e) {
      //디렉토리 삭제 후 초기화
      print("chcek device_service, 45");
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 16.0);
      //throw BaseException(ErrorCode.NEED_SIGN_IN, "Device service error");
    }

    return characters;
  }

  static Future<String> saveCharacterFile(
      Uint8List bytes, String extension, String id, String name) async {
    final directory =
        Directory("${await getStoryMakingDirectory()}/characters");

    if (await directory.exists()) {
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        format: CompressFormat.jpeg,
        quality: 75,
      );

      final characterDirectory = Directory("${directory.path}/$id");
      characterDirectory.create();

      final jpgFile = File('${directory.path}/$id/img.jpeg');
      final infoFile = File('${directory.path}/$id/info.json');
      final jsonStr = json.encode({
        'name': name,
        'id': id,
      });

      // Write the compressed bytes to the temporary file
      await jpgFile.writeAsBytes(compressedBytes);
      await infoFile.writeAsString(jsonStr);
    } else {
      throw BaseException(
          ErrorCode.NEED_SIGN_IN, "Character Make Directory Does Not Exist");
    }

    return id;
  }

  static Future<String> changeImageFile(
      String imgUrl, String id, String name) async {
    final directory =
        Directory("${await getStoryMakingDirectory()}/characters");

    if (await directory.exists()) {
      final characterDirectory = Directory("${directory.path}/$id");
      //S3 이미지 다운로드
      final http.Response response = await http.get(Uri.parse(imgUrl));
      developer.log(response.body, name: "imgurl");
      if (await characterDirectory.exists()) {
        final jpgFile = File('${directory.path}/$id/img.jpeg');
        jpgFile.delete();
        await jpgFile.writeAsBytes(response.bodyBytes);
        developer.log(jpgFile.toString(), name: "jpgFile");
      }
    } else {
      throw BaseException(
          ErrorCode.NEED_SIGN_IN, "Character Make Directory Does Not Exist");
    }

    return id;
  }
}
