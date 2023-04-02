import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:igrim/models/character_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:developer' as developer;

class DeviceService {
  static void clean() async {
    final bdirectory =
        Directory("${await getStoryMakingDirectory()}/charcters");
    if (await bdirectory.exists()) {
      bdirectory.delete(recursive: true);
      developer.log("StoryMakingDirectoryDeleted", name: "DeviceService");
    }
  }

  static Future<String> getStoryMakingDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> makeStoryMakingDirectory() async {
    ///
    final directory = Directory("${await getStoryMakingDirectory()}/charcters");
    directory.create(); //create directory if doesn't exits
    return directory.path;
  }

  //static Future<bool> deleteStoryMakingDirectory() async {}
  static Future<List<CharacterModel>> getCharacters() async {
    final directory = Directory("${await getStoryMakingDirectory()}/charcters");
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

            final character =
                CharacterModel.fromJson(json.decode(await info.readAsString()));
            characters.add(character);
          } else {
            //error
            throw Exception("Directory Not Found");
          }
        });
      } else {
        //characters not created yet
      }
    } catch (e) {
      //디렉토리 삭제 후 초기화
      print("chcek device_service, 45");
    }

    return Future.value(characters);
  }

  Future<String> saveCharacterFile(
      Uint8List bytes, String extension, CharacterModel characterModel) async {
    final id = characterModel.id;
    final directory = Directory("${await getStoryMakingDirectory()}/charcters");

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
      final jsonStr = characterModel.toJson();
      // Write the compressed bytes to the temporary file
      await jpgFile.writeAsBytes(compressedBytes);
      await infoFile.writeAsString(jsonStr);
      developer.log("Charater : ${characterModel.name}, ${characterModel.id}");
    } else {
      throw Exception("Character Make Directory Does Not Exist");
    }

    return id;
  }
}
