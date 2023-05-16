import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';

class StoryViewer extends StatefulWidget {
  final String storyId;
  final String title;
  const StoryViewer({super.key, required this.storyId, required this.title});

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: PageFlipWidget(
            showDragCutoff: false,
            backgroundColor: Colors.white,
            children: <Column>[
              Column(children: [
                Expanded(
                  flex: 3,
                  child: Image.network(
                    "https://cdn.eyesmag.com/content/uploads/posts/2020/08/11/the-patrick-star-show-spongebob-squarepants-spin-off-1-516d0d4f-fcf0-4106-ab95-a407167fee2c.jpg",
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 1000,
                    decoration: const BoxDecoration(
                      
                        border: Border(
                            bottom: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black))),
                    child: const Text(
                      "옛날옛날 눈이 오는 어느 숲속 마을에 한 소녀가 살고 있었어요.",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ]),
              Column(children: [
                Image.network(
                    "https://cdn.edujin.co.kr/news/photo/202102/35063_66368_1421.jpg",
                    width: 600,
                    height: 600),
                const Text("data")
              ]),
            ]),
      ),
    );
  }
}
