import 'package:flutter/material.dart';
import 'package:igrim/dtos/page_create_req_dto.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/models/character_model.dart';
import 'package:igrim/services/device_service.dart';
import 'package:igrim/services/open_api_service.dart';
import 'package:igrim/services/story_service.dart';
import 'package:igrim/widgets/loading_widget.dart';
import 'dart:developer' as developer;

import 'package:igrim/widgets/resizable_image.dart';

class StoryMakeScreen extends StatefulWidget {
  final String storyId;
  const StoryMakeScreen(this.storyId, {super.key});

  @override
  State<StoryMakeScreen> createState() => _StoryMakeScreenState();
}

class _StoryMakeScreenState extends State<StoryMakeScreen> {
  int currentPage = 0;
  final String defaultUrl =
      "https://liftlearning.com/wp-content/uploads/2020/09/default-image.png";
  Future<List<CharacterModel>> characters = DeviceService.getCharacters();
  TextEditingController textEditingController = TextEditingController();
  String url =
      "https://liftlearning.com/wp-content/uploads/2020/09/default-image.png";

  @override
  Widget build(BuildContext context) {
    Future<List<CharacterModel>> characters = DeviceService.getCharacters();
    developer.log("build StoryMakeScreen", name: "StoryMakeScreen");
    return FutureBuilder(
      future: characters,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(
                  "장면 ${currentPage + 1}",
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              body: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Stack(children: [
                        Image.network(
                          url,
                          height: 300,
                          width: 600,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        for (var v in snapshot.data!)
                          ResizableImage(image: v.image)
                      ]),
                      const SizedBox(
                        height: 3,
                      ),
                      TextField(
                        controller: textEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "이야기를 작성해주세요",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                try {
                                  characters = DeviceService.getCharacters();
                                } on BaseException {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "cannot upload characters from device..."),
                                  ));
                                }
                              });
                            },
                            child: const Text('새로고침'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                  // The user CANNOT close this dialog  by pressing outsite it
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return const LoadingWidget(
                                        text: "배경 이미지 생성중...");
                                  });
                              developer.log(textEditingController.text);
                              url = await OpenApiService.generateImage(
                                  await OpenApiService.getKeywords(
                                      textEditingController.text));
                              developer.log(url, name: "StoryMakeScreen");
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text('그림 생성'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                  // The user CANNOT close this dialog  by pressing outsite it
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return const LoadingWidget(
                                        text: "데이터 전송중...");
                                  });
                              try {
                                // createPage API 연결
                                String response =
                                    await OpenApiService.getCharacterPrompt(
                                        textEditingController.text);
                                List<String> parsedResponse =
                                    response.split("\n");
                                List<String> characterName = [];
                                List<String> characterPrompt = [];

                                for (String line in parsedResponse) {
                                  if (line.contains(":")) {
                                    List<String> splits = line.split(":");
                                    characterName.add(splits[0]);
                                    characterPrompt.add(splits[1]);
                                  } else {
                                    break;
                                  }
                                }

                                parsedResponse[0].split(":")[0];
                                // TODO : createPage api에 캐릭터 좌표도 필요
                                StoryService.createPage(
                                  widget.storyId,
                                  PageCreateReqDto(
                                    content: textEditingController.text,
                                    characterName: characterName,
                                    characterPrompt: characterPrompt,
                                    imgUrl: url,
                                    pageNum: currentPage,
                                    x: 500,
                                    y: 750,
                                  ),
                                ).then((value) => {
                                      Navigator.of(context).pop(),
                                      textEditingController.clear(),
                                      currentPage++,
                                      url = defaultUrl,
                                      setState(() {}),
                                    });
                              } on Exception {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("오류. 다시시도 해주세요..."),
                                ));
                              }
                            },
                            child: const Text('다음 장면'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            child: const Text('완료하기'),
                          )
                        ],
                      )
                    ],
                  )));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
