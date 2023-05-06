import 'dart:convert';

class MakeNewCharacterReqDto {
  String name;
  MakeNewCharacterReqDto(this.name);

  String toJson() => json.encode({
        'name': name,
      });

  @override
  String toString() {
    return "{'name' : $this.name}";
  }
}
