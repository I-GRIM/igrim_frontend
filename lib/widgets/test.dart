// import 'package:flutter/material.dart';
// import 'package:igrim/dtos/page_create_req_dto.dart';
// import 'package:igrim/models/character_model.dart';
// import 'package:igrim/services/device_service.dart';
// import 'package:igrim/services/open_api_service.dart';
// import 'package:igrim/services/story_service.dart';
// import 'dart:developer' as developer;
// import 'package:igrim/widgets/loading_widget.dart';
// import 'package:igrim/widgets/resizable_image.dart';

// class StoryMakeScreen extends StatefulWidget {
//   final String storyId;
//   const StoryMakeScreen(this.storyId, {super.key});

//   @override
//   State<StoryMakeScreen> createState() => _StoryMakeScreenState();
// }

// class _StoryMakeScreenState extends State<StoryMakeScreen> {
//   GlobalKey captureKey = GlobalKey();
//   List<String> story = [];
//   int currentPage = 0;
//   final String defaultUrl =
//       "https://liftlearning.com/wp-content/uploads/2020/09/default-image.png";
//   String url =
//       "https://liftlearning.com/wp-content/uploads/2020/09/default-image.png";
//   List<double> scales = [0];
//   List<Widget> charactersInImage = [
//     Image.network(
//       "https://liftlearning.com/wp-content/uploads/2020/09/default-image.png",
//       width: 800,
//       height: 800,
//       loadingBuilder: (BuildContext context, Widget child,
//           ImageChunkEvent? loadingProgress) {
//         if (loadingProgress == null) {
//           return child;
//         }
//         return Center(
//           child: CircularProgressIndicator(
//             value: loadingProgress.expectedTotalBytes != null
//                 ? loadingProgress.cumulativeBytesLoaded /
//                     loadingProgress.expectedTotalBytes!
//                 : null,
//           ),
//         );
//       },
//     ),
//   ];
//   Future<List<CharacterModel>> characters = DeviceService.getCharacters();

//   TextEditingController textEditingController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     developer.log("build StoryMakeScreen", name: "StoryMakeScreen");
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(
//           "장면 ${currentPage + 1}",
//           style: const TextStyle(fontSize: 24),
//         ),
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(
//                       flex: 2,
//                       child: Stack(
//                         key: captureKey,
//                         children: charactersInImage,
//                       )),
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       children: [
//                         FutureBuilder(
//                             future: DeviceService.getCharacters(),
//                             builder: ((context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               } else if (snapshot.hasError) {
//                                 return const Text("error");
//                               } else {
//                                 return Expanded(
//                                   child: makeList(snapshot),
//                                 );
//                               }
//                             })),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 100,
//               child: TextField(
//                 controller: textEditingController,
//                 keyboardType: TextInputType.multiline,
//                 maxLines: 10,
//                 style: const TextStyle(fontSize: 20),
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: "이야기를 작성해 주세요",
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     if (currentPage != 0) {
//                 //       setState(() {
//                 //         textEditingController.clear();
//                 //         currentPage--;
//                 //         if (story.length > currentPage) {
//                 //           textEditingController.text = story[currentPage];
//                 //         }
//                 //       });
//                 //     }
//                 //   },
//                 //   child: const Text('이전'),
//                 // ),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     showDialog(
//                         // The user CANNOT close this dialog  by pressing outsite it
//                         barrierDismissible: false,
//                         context: context,
//                         builder: (_) {
//                           return const LoadingWidget(text: "배경 이미지 생성중...");
//                         });
//                     developer.log(textEditingController.text);
//                     story.add(textEditingController.text);
//                     url = await OpenApiService.generateImage(
//                         await OpenApiService.getKeywords(
//                             textEditingController.text));
//                     developer.log(url, name: "StoryMakeScreen");
//                     setState(() {
//                       Navigator.of(context).pop();
//                     });
//                   },
//                   child: const Text('저장'),
//                 ),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (story.length <= currentPage) {
//                       //스토리 작성하고 넘어가도록
//                     } else {
//                       setState(() {
//                         if (story.length > currentPage) {
//                           textEditingController.text = story[currentPage];
//                         }
//                       });
//                       showDialog(
//                           // The user CANNOT close this dialog  by pressing outsite it
//                           barrierDismissible: false,
//                           context: context,
//                           builder: (_) {
//                             return const LoadingWidget(text: "데이터 전송중...");
//                           });
//                       // createPage API 연결
//                       String response = await OpenApiService.getCharacterPrompt(
//                           story[currentPage]);
//                       List<String> parsedResponse = response.split("\n");
//                       List<String> characterName = [];
//                       List<String> characterPrompt = [];
//                       for (String line in parsedResponse) {
//                         List<String> splits = line.split(":");
//                         characterName.add(splits[0]);
//                         characterPrompt.add(splits[1]);
//                       }

//                       parsedResponse[0].split(":")[0];

//                       StoryService.createPage(
//                         widget.storyId,
//                         PageCreateReqDto(story[currentPage], characterName,
//                             characterPrompt, url, currentPage),
//                       ).then((value) => {
//                             Navigator.of(context).pop(),
//                             textEditingController.clear(),
//                             currentPage++,
//                             url = defaultUrl,
//                             setState(() {}),
//                           });
//                     }
//                   },
//                   child: const Text('다음'),
//                 ),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     //로딩창
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return WillPopScope(
//                           onWillPop: () async => false,
//                           child: const Dialog(
//                             child: LoadingWidget(text: "동화를 생성중 입니다."),
//                           ),
//                         );
//                       },
//                     );
//                     //AI API 연결
//                     //API.then 해서 끝날 떄 까지 배경 사진 iterate
//                   },
//                   child: const Text(
//                     '동화 생성',
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onScaleUpdate(double scale, int index) {
//     setState(() {
//       scales[index] = scale;
//     });
//   }

//   ListView makeList(AsyncSnapshot<List<CharacterModel>> snapshot) {
//     return ListView.separated(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       itemBuilder: (BuildContext context, int index) {
//         var character = snapshot.data![index];
//         double x = 0;
//         double y = 0;
//         return Draggable(
//           feedback: Image.file(
//             character.image,
//             width: 100,
//             height: 100,
//           ),
//           child: Image.file(character.image),
//           onDragEnd: (dragDetails) {
//             x = dragDetails.offset.dx;
//             y = dragDetails.offset.dy;
//             setState(() {
//               scales.add(1.0);
//               charactersInImage.add(Positioned(
//                 top: y,
//                 left: x,
//                 child: ResizableImage(
//                   initialScale: scales[charactersInImage.length],
//                   index: charactersInImage.length,
//                   image: character.image,
//                   onScaleUpdate: _onScaleUpdate,
//                 ),
//               ));
//             });
//           },
//         );
//       },
//       separatorBuilder: (BuildContext context, int index) => const SizedBox(
//         width: 40,
//       ),
//       itemCount: snapshot.data!.length,
//     );
//   }
// }
