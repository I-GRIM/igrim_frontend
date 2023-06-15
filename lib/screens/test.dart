import 'package:flutter/material.dart';

import 'package:igrim/services/open_api_service.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  TextEditingController textEditingController = TextEditingController();
  String txt = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("캐릭터 프롬프트 test"),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(children: [
            TextField(controller: textEditingController),
            Text(txt),
            TextButton(
              onPressed: () async {
                String result = await OpenApiService.getCharacterPrompt(
                    textEditingController.text, "동연");
                print(result);
                txt = result;
                setState(() {});
              },
              child: const Text("Go", style: TextStyle(fontSize: 100)),
            ),
          ]),
        ));
  }
}
