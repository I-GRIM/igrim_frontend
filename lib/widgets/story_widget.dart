import 'package:flutter/material.dart';
import 'package:igrim/screens/story_viewer.dart';

class StoryWidget extends StatelessWidget {
  final String storyId;
  final String title;
  final String author;
  final Image thumb;

  const StoryWidget(
      {super.key,
      required this.storyId,
      required this.title,
      required this.author,
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
                      title : title,
                    )),
          );
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black87, width: 5)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: thumb,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
              ),
            )
          ],
        ),
      );
    });
  }
}
