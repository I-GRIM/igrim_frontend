import 'package:flutter/material.dart';
import 'package:igrim/dtos/story_create_req_dto.dart';
import 'package:igrim/screens/character_make_screen.dart';
import 'dart:developer' as developer;

import 'package:igrim/services/story_service.dart';

class StoryNewTitleScreen extends StatefulWidget {
  const StoryNewTitleScreen({super.key});

  @override
  State<StoryNewTitleScreen> createState() => _StoryNewTitleScreenState();
}

class _StoryNewTitleScreenState extends State<StoryNewTitleScreen> {
  List<String> story = [];
  int currentPage = 0;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    developer.log("build StoryMakeScreen", name: "StoryMakeScreen");
    TextEditingController titleController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("제목을 입력해 주세요"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
            controller: titleController,
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text != '') {
                StoryService.createStory(
                        StoryCreateReqDto(titleController.text))
                    .then((value) => {
                          developer.log(value.toString(),
                              name: "StoryNewTitleScreen"),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CharacterMakeScreen(value.storyId)),
                          )
                        });
              }
            },
            child: const Text(
              '확인',
            ),
          ),
        ]),
      ),
    );
  }
}
