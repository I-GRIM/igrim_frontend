import 'package:flutter/material.dart';
import 'package:igrim/screens/drawing_page.dart';

class CharacterWidget extends StatelessWidget {
  final String name;

  const CharacterWidget({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DrawingPage()));
      },
      child: Column(
        children: [
          const Image(image: AssetImage('imgs/add_character.png')),
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
