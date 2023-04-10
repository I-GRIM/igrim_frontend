import 'dart:convert';

class MakeNewCharacterReqDto {
  String title;
  List<String> names;

  MakeNewCharacterReqDto(this.title, this.names);

  String toJson() => json.encode({
        'title': title,
        'names': names,
      });
}
