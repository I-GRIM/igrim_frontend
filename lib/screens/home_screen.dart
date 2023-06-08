import 'package:flutter/material.dart';
import 'package:igrim/dtos/get_all_story_res_dto.dart';
import 'package:igrim/screens/story_new_title_screen.dart';
import 'package:igrim/services/story_service.dart';
import 'dart:developer' as developer;

import 'package:igrim/widgets/story_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  Future<List<GetAllStoryResDto>> storyList = StoryService.getAllStory();

  //final Future<List<StoryModel>> storyList = StoryService.getAllStory();
  @override
  Widget build(BuildContext context) {
    developer.log("Build HomeScreen", name: "HomeScreen");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blue,
        title: const Text(
          "책그림",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'GamjaFlower',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/imgs/main_background.jpg"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 55),
            const Text("동화목록",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
            //동화 리스트 빌더
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
                      builder: (context) => const StoryNewTitleScreen()),
                );
              },
              child: const Text(
                '동화 만들러 가기',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'GamjaFlower',
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 동화 리스트 생성
  ListView makeList(AsyncSnapshot<List<GetAllStoryResDto>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
        var story = snapshot.data![index];
        if (story.titleImgUrl == "0") {
          return StoryWidget(
            storyId: story.id,
            title: story.title,
            thumb: Image.asset(
              "assets/imgs/logo.jpg",
              height: 300,
              width: 300,
            ),
          );
        } else {
          return StoryWidget(
            storyId: story.id,
            title: story.title,
            thumb: Image.network(
              story.titleImgUrl,
              height: 300,
              width: 300,
            ),
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
