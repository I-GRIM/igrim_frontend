import 'dart:io';

class StoryModel {
  final String title, author;
  final File thumb;

  StoryModel({required this.author, required this.thumb, required this.title});

  StoryModel.fromJson(Map<String, dynamic> json, File thumbnail)
      : title = json['title'],
        author = json['author'],
        thumb = thumbnail;
}
