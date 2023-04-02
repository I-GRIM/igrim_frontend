import 'package:flutter/material.dart';
import 'package:igrim/models/character_model.dart';
import 'package:igrim/screens/drawing_screen.dart';
import 'package:igrim/screens/home_screen.dart';
import 'package:igrim/services/device_service.dart';
import 'dart:developer' as developer;

class CharacterMakeScreen extends StatefulWidget {
  const CharacterMakeScreen({super.key});

  @override
  State<CharacterMakeScreen> createState() => _CharacterMakeScreenState();
}

class _CharacterMakeScreenState extends State<CharacterMakeScreen> {
  final storyMakingDirectoryPath = DeviceService.makeStoryMakingDirectory();
  Future<List<CharacterModel>> characters = DeviceService.getCharacters();

  void onGoBack(dynamic value) {
    characters = DeviceService.getCharacters().then((value) {
      setState(() {});
      return value;
    });
    developer.log(
        "refresh characters : ${characters.then((value) {
          for (var element in value) {
            return element;
          }
        })}",
        name: "CharacterMakeScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("character screen"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: characters,
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
          Center(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text('뒤로가기'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DrawingScreen()),
                    ).then(onGoBack);
                  },
                  child: const Text('새로운 캐릭터 만들기'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text('스토리 작성'),
                ),
              ],
            ),
          ),
        ],
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
        return CharacterWidget(
          name: character.name,
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

  const CharacterWidget({
    super.key,
    required this.name,
  });

  void onGoBack() {}
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Image(
          image: AssetImage('assets/imgs/add_character.png'),
          height: 100,
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
