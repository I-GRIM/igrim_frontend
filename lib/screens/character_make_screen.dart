import 'dart:io';

import 'package:flutter/material.dart';
import 'package:igrim/models/character_model.dart';
import 'package:igrim/screens/drawing_screen.dart';
import 'package:igrim/services/device_service.dart';
import 'dart:developer' as developer;

class CharacterMakeScreen extends StatefulWidget {
  const CharacterMakeScreen({super.key});

  @override
  State<CharacterMakeScreen> createState() => _CharacterMakeScreenState();
}

class _CharacterMakeScreenState extends State<CharacterMakeScreen> {
  final storyMakingPath = DeviceService.makeStoryMakingDirectory();
  late Future<List<CharacterModel>> characters;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      characters = DeviceService.getCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("캐릭터 생성"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            FutureBuilder(
              future: characters,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  developer.log("update future builder ${snapshot.data}",
                      name: "CharacterMakeScreen");
                  return Expanded(
                    child: makeList(snapshot),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('뒤로가기'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DrawingScreen()),
                      ).then((value) => setState(() {
                            characters = DeviceService.getCharacters();
                          }));
                    },
                    child: const Text('새로운 캐릭터 만들기'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var characterList = await characters;
                      // CharacterService.makeNewCharacters(MakeNewCharacterReqDto("title", ))
                      //     .then((response) => {
                      //           if (response.code == 200)
                      //             {
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         const StoryMakeScreen()),
                      //               )
                      //             }
                      //           else
                      //             {
                      //               //makeNewCharacters fail
                      //               response.message
                      //             }
                      //         });
                    },
                    child: const Text('스토리 작성'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<CharacterModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
        var character = snapshot.data![index];
        developer.log("build character : ${character.id}",
            name: "CharacterMakeScreen");
        return CharacterWidget(
          name: character.name,
          id: character.id,
          image: character.image,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        width: 40,
      ),
    );
  }
}

class CharacterWidget extends StatelessWidget {
  final String name;
  final String id;
  final File image;
  const CharacterWidget({
    super.key,
    required this.name,
    required this.id,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.file(
          image,
          width: 300,
          height: 300,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
