import 'dart:async';
import 'package:igrim/models/character_model.dart';
import 'package:path_provider/path_provider.dart';

class DeviceService {
  static Future<String> getTempDirectory() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  static List<CharacterModel> getCharacters() {
    //final directory = await getTemporaryDirectory();
    //return directory.path;
    List<CharacterModel> characters = [];
    characters.add(CharacterModel("dad", "img"));
    characters.add(CharacterModel("mom", "img"));
    characters.add(CharacterModel("새로운 캐릭터 추가", "img"));

    return characters;
  }
  // Future<File> writeCharacter(CharacterModel characterModel, String id) async {
  //   final path = await getTempDirectory() + "/charater/id";

  //   var name = characterModel.name;
  //   var img = characterModel.img;

  // }
}
