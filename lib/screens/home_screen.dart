import 'package:flutter/material.dart';
import 'package:igrim/models/story_model.dart';
import 'package:igrim/screens/character_make_screen.dart';
import 'dart:developer' as developer;

import 'package:igrim/widgets/story_widget.dart';

Future<List<StoryModel>> dummy() async {
  List<StoryModel> storyList = [];
  for (int i = 0; i < 20; i++) {
    storyList.add(StoryModel(
        author: "원동연 어린이",
        thumb: Image.asset("assets/imgs/logo.jpg"),
        title: "삼맨동연"));
  }
  Future.delayed(const Duration(seconds: 3));
  return storyList;
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<StoryModel>> storyList = dummy();
  @override
  Widget build(BuildContext context) {
    developer.log("Build HomeScreen", name: "HomeScreen");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text(
          "책그림",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 동화 리스트 빌더
          FutureBuilder(
            future: storyList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: makeList(snapshot),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CharacterMakeScreen()),
              );
            },
            child: const Text(
              '동화 만들러 가기',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  // 동화 리스트 생성
  ListView makeList(AsyncSnapshot<List<StoryModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
        var story = snapshot.data![index];
        return StoryWidget(
            title: story.title, author: story.author, thumb: story.thumb);
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
