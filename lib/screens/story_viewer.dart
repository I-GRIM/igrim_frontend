import 'package:flutter/material.dart';
import 'package:igrim/dtos/get_story_by_id_res_dto.dart';
import 'package:igrim/services/story_service.dart';

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
    Future<List<GetStoryByIdResDto>> pages =
        StoryService.getStoryById(widget.storyId);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: pages,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 1000,
                      width: 1185,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/imgs/story_viewer_background.jpg"))),
                      child: Column(
                        children: [
                          Image.network(
                            snapshot.data?[index].imgUrl ?? "deafult",
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("/assets/imgs/logo.png");
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: const BoxDecoration(),
                            child: Text(
                              snapshot.data?[index].content ?? "---",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
