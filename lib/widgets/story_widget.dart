import 'dart:io';

import 'package:flutter/material.dart';

class StoryWidget extends StatelessWidget {
  final String title;
  final String author;
  final File thumb;

  const StoryWidget(
      {super.key,
      required this.title,
      required this.author,
      required this.thumb});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Image.file(thumb), Text(title)],
    );
  }
}
