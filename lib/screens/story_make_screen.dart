import 'dart:convert';

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

import 'package:igrim/widgets/notify_widget.dart';

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
  double x = 0.0;
  double y = 0.0;
  @override
  Widget build(BuildContext context) {
    developer.log("build StoryMakeScreen", name: "StoryMakeScreen");
    return FutureBuilder(
      future: characters,
      builder: (context, snapshot) {
        double prex = 0.0;
        double prey = 0.0;
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Stack(children: [
                          Positioned(
                            child: Image.network(
                              url,
                              height: 512,
                              width: 512,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return Center(
                                      heightFactor: 512,
                                      widthFactor: 512,
                                      child: child);
                                }
                                return Center(
                                  heightFactor: 512,
                                  widthFactor: 512,
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          for (var v in snapshot.data!.asMap().entries)
                            Positioned(
                              left: x,
                              top: y,
                              child: GestureDetector(
                                child: Image.file(v.value.image),
                                onPanDown: (details) {
                                  prex = details.localPosition.dx;
                                  prey = details.localPosition.dy;
                                },
                                onPanUpdate: (DragUpdateDetails details) {
                                  double xx = details.delta.dx;
                                  double yy = details.delta.dy;
                                  x += xx;
                                  y += yy;
                                  x = x.clamp(0, 512 - 100);
                                  y = y.clamp(0, 512 - 100);
                                  developer.log("$x, $y", name: "x,y");

                                  setState(() {});
                                },
                              ),
                            )
                        ]),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 550,
                            child: TextField(
                              controller: textEditingController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "이야기를 작성해주세요",
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    try {
                                      characters =
                                          DeviceService.getCharacters();
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
                                    List<CharacterModel> charac =
                                        await characters;
                                    String response =
                                        await OpenApiService.getCharacterPrompt(
                                            textEditingController.text,
                                            charac[0].name);
                                    developer.log(response[0]);
                                    if (response.isEmpty ||
                                        response[0] != '{') {
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                          msg: "unable to parse gpt prompt",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.white,
                                          textColor: Colors.red,
                                          fontSize: 16.0);
                                    } else {
                                      // {"상윤": {"emotion": "happy", "behavior": "eating snacks"}}
                                      developer.log(charac[0].name);
                                      Map<String, dynamic> data =
                                          json.decode(response);
                                      String emotions =
                                          data[charac[0].name]['emotion'] ?? "";
                                      String behavior = data[charac[0].name]
                                              ['behavior'] ??
                                          "";
                                      List<String> pt = [];
                                      if (emotions.contains("null") ||
                                          emotions.contains("neutral")) {
                                        emotions = "";
                                      }
                                      if (behavior.contains("null")) {
                                        behavior = "";
                                      }
                                      developer.log(charac[0].name,
                                          name: "name");
                                      developer.log(emotions, name: "emotions");
                                      developer.log(behavior, name: "behavior");
                                      // TODO : createPage api에 캐릭터 좌표도 필요
                                      StoryService.createPage(
                                        widget.storyId,
                                        PageCreateReqDto(
                                            content: textEditingController.text,
                                            characterName: [charac[0].name],
                                            characterPrompt: [
                                              emotions,
                                              behavior
                                            ],
                                            imgUrl: url,
                                            pageNum: currentPage,
                                            x: x.ceil(),
                                            y: y.ceil()),
                                      ).then((value) {
                                        if (value.storyId == "") {
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(
                                              msg: "문법을 확인 해 주세요",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.red,
                                              fontSize: 16.0);
                                          //변경하려는 텍스트
                                          String txt =
                                              textEditingController.text;
                                          //문법 오류

                                          List<String> parse =
                                              value.content.split(",");
                                          List<String> wrong = [];
                                          List<String> right = [];
                                          for (var element in parse) {
                                            wrong.add(element.split(" ")[1]);
                                            right.add(element.split(" ")[2]);
                                          }
                                          showDialog(
                                              // The user CANNOT close this dialog  by pressing outsite it
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (_) {
                                                return NotifyWidget(
                                                    right: right, wrong: wrong);
                                              });
                                        } else {
                                          Navigator.of(context).pop();
                                          textEditingController.clear();
                                          currentPage++;
                                          url = defaultUrl;
                                          setState(() {});
                                        }
                                      });
                                    }
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
                      ),
                    ],
                  )));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
