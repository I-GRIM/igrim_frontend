import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:igrim/widgets/loading_widget.dart';

class StoryMakeScreen extends StatefulWidget {
  const StoryMakeScreen({super.key});

  @override
  State<StoryMakeScreen> createState() => _StoryMakeScreenState();
}

class _StoryMakeScreenState extends State<StoryMakeScreen> {
  List<String> story = [];
  int currentPage = 0;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    developer.log("build StoryMakeScreen", name: "StoryMakeScreen");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("이야기 작성"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "장면 ${currentPage + 1}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "이야기를 작성해 주세요",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (currentPage != 0) {
                      setState(() {
                        textEditingController.clear();
                        currentPage--;
                        if (story.length > currentPage) {
                          textEditingController.text = story[currentPage];
                        }
                      });
                    }
                  },
                  child: const Text('이전'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    story.add(textEditingController.text);
                  },
                  child: const Text('저장'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (story.length <= currentPage) {
                      //스토리 작성하고 넘어가도록
                    } else {
                      setState(() {
                        textEditingController.clear();
                        currentPage++;
                        if (story.length > currentPage) {
                          textEditingController.text = story[currentPage];
                        }
                      });
                    }
                  },
                  child: const Text('다음'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                //api
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: const Dialog(
                        child: LoadingWidget(text: "동화를 생성중 입니다."),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                '동화 생성',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
