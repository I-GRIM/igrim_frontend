import 'package:flutter/material.dart';
import 'package:igrim/screens/story_viewer.dart';

class StoryWidget extends StatelessWidget {
  final String storyId;
  final String title;
  final Image thumb;

  const StoryWidget(
      {super.key,
      required this.storyId,
      required this.title,
      required this.thumb});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryViewer(
                      storyId: storyId,
                      title: title,
                    )),
          );
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: thumb,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 26,
                  fontFamily: "assets/fonts/Cafe24Ssurround",
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    });
  }
}
