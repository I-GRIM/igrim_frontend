import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:igrim/dtos/page_create_req_dto.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/models/character_model.dart';
import 'package:igrim/screens/home_screen.dart';
import 'package:igrim/services/device_service.dart';
import 'package:igrim/services/open_api_service.dart';
import 'package:igrim/services/story_service.dart';
import 'package:igrim/widgets/loading_widget.dart';
import 'dart:developer' as developer;

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
  var x = 0.0;
  var y = 0.0;
  double prex = 0.0;
  double prey = 0.0;
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
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Image.network(
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
                        ),
                        Positioned(
                          left: x,
                          top: y,
                          child: GestureDetector(
                            child: Image.network(
                                "https://bryanbrattlof.com/you-me-machines-learning/low-resolution-6.png"),
                            onPanDown: (details) {
                              prex = details.localPosition.dx;
                              prey = details.localPosition.dy;
                            },
                            onPanUpdate: (details) {
                              double xx = details.localPosition.dx - prex;
                              double yy = details.localPosition.dy - prey;
                              developer.log(x.toString(), name: "x");
                              developer.log(y.toString(), name: "y");
                              x = xx;
                              y = yy;
                              setState(() {});
                            },
                          ),
                        )

                        // ResizableImage(
                        //   image: v.image,
                        //   onUpdate: (x, y) {
                        //     xy.x = x;
                        //     xy.y = y;
                        //   },
                        // )
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
                              try {
                                url = await OpenApiService.generateImage(
                                    await OpenApiService.getKeywords(
                                        textEditingController.text));
                                developer.log(url, name: "StoryMakeScreen");
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              } on Exception catch (e) {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                    msg: e.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.red,
                                    fontSize: 16.0);
                              }
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
                                        textEditingController.text, "동연");
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
                                      x: x.ceil(),
                                      y: y.ceil()),
                                ).then((value) => {
                                      Navigator.of(context).pop(),
                                      textEditingController.clear(),
                                      currentPage++,
                                      url = defaultUrl,
                                      setState(() {}),
                                    });
                              } on Exception catch (e) {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                    msg: e.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.red,
                                    fontSize: 16.0);
                              }
                            },
                            child: const Text('다음 장면'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
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
