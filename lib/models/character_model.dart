import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class CharacterModel {
  String name, id;
  File image;

  CharacterModel(this.name, this.id, this.image);

  CharacterModel.fromJson(Map<String, dynamic> json, File img)
      : name = json['name'],
        id = json['id'],
        image = img;
  
  

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());
}
