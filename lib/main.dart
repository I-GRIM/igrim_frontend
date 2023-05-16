import 'package:flutter/material.dart';
import 'package:igrim/screens/story_viewer.dart';
import 'package:igrim/services/device_service.dart';

void main() {
  runApp(const App());
}

late String path;
const Color kCanvasColor = Color(0xfff2f3f7);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    DeviceService.clean();
    return MaterialApp(
      title: '책그림',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const StoryViewer(
        storyId: "ss",
        title: "제목",
      ),
    );
  }
}
