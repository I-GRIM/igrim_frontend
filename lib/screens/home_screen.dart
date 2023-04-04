import 'package:flutter/material.dart';
import 'package:igrim/models/story_model.dart';
import 'package:igrim/screens/character_make_screen.dart';
import 'dart:developer' as developer;

import 'package:igrim/widgets/story_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    developer.log("Build HomeScreen", name: "HomeScreeb");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "아이그림",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // 동화 리스트 빌더
          // FutureBuilder(
          //   future: webtoons,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Column(children: [
          //         const SizedBox(
          //           height: 50,
          //         ),
          //         Expanded(
          //           child: makeList(snapshot),
          //         ),
          //       ]);
          //     }
          //     return const Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   },
          // ),
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
