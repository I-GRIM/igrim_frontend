import 'package:flutter/material.dart';

class StoryModel {
  final String title, author;
  final Image thumb;
  final List<String> pages;

  StoryModel({required this.author, required this.thumb, required this.title, required this.pages});
  
  // StoryModel.fromJson(Map<String, dynamic> json, Image thumbnail)
  //     : title = json['title'],
  //       author = json['author'],
  //       thumb = thumbnail;
}
