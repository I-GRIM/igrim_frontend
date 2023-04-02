import 'dart:convert';

class CharacterModel {
  String name, id;

  CharacterModel(this.name, this.id);

  CharacterModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());
}
