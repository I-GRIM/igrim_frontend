import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:igrim/dtos/make_new_character_req_dto.dart';
import 'package:igrim/dtos/make_new_character_res_dto.dart';
import 'package:igrim/exceptions/base_exception.dart';
import 'package:igrim/models/drawing_mode.dart';
import 'package:igrim/models/sketch.dart';
import 'package:igrim/services/character_service.dart';
import 'package:igrim/services/device_service.dart';
import 'package:igrim/widgets/canvas_side_bar.dart';
import 'package:igrim/services/drawing_service.dart';
import 'package:igrim/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:igrim/widgets/loading_widget.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

class DrawingScreen extends HookWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = useState(Colors.black);
    final strokeSize = useState<double>(10);
    final eraserSize = useState<double>(30);
    final drawingMode = useState(DrawingMode.pencil);
    final filled = useState<bool>(false);
    final polygonSides = useState<int>(3);
    final backgroundImage = useState<Image?>(null);
    final canvasGlobalKey = GlobalKey();

    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: 1,
    );

    void onPressConfirm(name, bytes, extension) async {
      try {
        String id = const Uuid().v4();
        await DeviceService.saveCharacterFile(bytes, extension, id, name);
        String path = await DeviceService.getStoryMakingDirectory();
        MakeNewCharacterResDto makeNewCharacterResDto =
            await CharacterService.makeNewCharacter(
                MakeNewCharacterReqDto(name), "$path/characters/$id/img.jpeg");
        developer.log("start makeNewCharacterApi Done", name: "99kenny");
        developer.log(makeNewCharacterResDto.toString(),
            name: "makeNewcharacterResDto");
        String imgUrl = makeNewCharacterResDto.imgUrl;
        developer.log(imgUrl);
        // 이미지 url로 이미지 다운로드 후 이미지 교체
        await DeviceService.changeImageFile(imgUrl, id, name).then((value) => {
              Navigator.of(context).pop(), //pop 저장중
              Navigator.of(context).pop(), //pop drawing screen
              Navigator.of(context).pop(), //pop 캐릭터를 입력해주세요
            });
      } on BaseException catch (e) {
        Navigator.of(context).pop(); //pop 저장중
        Navigator.of(context).pop(); //pop drawing screen
        Navigator.of(context).pop(); //po
        developer.log(e.toString(), name: "error");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("cannot upload characters from device..."),
        ));
      }
    }

    void onSaveCharacter(name, bytes, extension) async {
      final textController = TextEditingController();
      String name = "";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              child: Column(
                children: [
                  const Text("캐릭터 이름을 입력해 주세요"),
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "캐릭터 이름을 입력해 주세요",
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: TextButton(
                      child: const Text('확인'),
                      onPressed: () {
                        if (textController.text == "") {
                          developer.log("empty text", name: "DrawingScreen");
                        } else {
                          name = textController.text;
                          showDialog(
                              // The user CANNOT close this dialog  by pressing outsite it
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return const LoadingWidget(text: "저장중");
                              });
                          onPressConfirm(name, bytes, extension);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          });
    }

    void onCancel() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: kCanvasColor,
            width: double.maxFinite,
            height: double.maxFinite,
            child: DrawingCanvas(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              drawingMode: drawingMode,
              selectedColor: selectedColor,
              strokeSize: strokeSize,
              eraserSize: eraserSize,
              sideBarController: animationController,
              currentSketch: currentSketch,
              allSketches: allSketches,
              canvasGlobalKey: canvasGlobalKey,
              filled: filled,
              polygonSides: polygonSides,
              backgroundImage: backgroundImage,
            ),
          ),
          Positioned(
            top: kToolbarHeight + 10,
            // left: -5,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animationController),
              child: CanvasSideBar(
                drawingMode: drawingMode,
                selectedColor: selectedColor,
                strokeSize: strokeSize,
                eraserSize: eraserSize,
                currentSketch: currentSketch,
                allSketches: allSketches,
                canvasGlobalKey: canvasGlobalKey,
                filled: filled,
                polygonSides: polygonSides,
                backgroundImage: backgroundImage,
                onSaveCharacter: onSaveCharacter,
                onCancel: onCancel,
              ),
            ),
          ),
          _CustomAppBar(animationController: animationController),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final AnimationController animationController;

  const _CustomAppBar({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (animationController.value == 0) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              icon: const Icon(Icons.menu),
            ),
            const Text(
              '캐릭터를 그려주세요',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
