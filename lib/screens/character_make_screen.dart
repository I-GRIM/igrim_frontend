import 'package:flutter/material.dart';
import 'package:igrim/models/character_model.dart';
import 'package:igrim/screens/home_screen.dart';
import 'package:igrim/services/device_service.dart';
import 'package:igrim/widgets/character_widget.dart';

class CharacterMakeScreen extends StatelessWidget {
  CharacterMakeScreen({super.key});

  final List<CharacterModel> characters = DeviceService.getCharacters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("character screen"),
      ),
      body: Column(
        children: [
          Expanded(
            child: makeList(characters),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text('Go back!'),
            ),
          ),
        ],
      ),
    );
  }

  ListView makeList(List<CharacterModel> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        var character = snapshot[index];
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
