import 'package:flutter/material.dart';

class StoryModel {
  final String title, author;
  final Image thumb;

  StoryModel({required this.author, required this.thumb, required this.title});

  StoryModel.fromJson(Map<String, dynamic> json, Image thumbnail)
      : title = json['title'],
        author = json['author'],
        thumb = thumbnail;
}
