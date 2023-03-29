import 'package:flutter/material.dart';
import 'package:igrim/screens/character_make_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //final Future<List<TaleModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "아이그림",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // 동화 리스트 빌더
          // FutureBuilder(
          //   future: webtoons,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Column(children: [
          //         const SizedBox(
          //           height: 50,
          //         ),
          //         Expanded(
          //           child: makeList(snapshot),
          //         ),
          //       ]);
          //     }
          //     return const Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   },
          // ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CharacterMakeScreen()),
              );
            },
            child: const Text(
              '동화 만들러 가기',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  // 동화 리스트 생성
  // ListView makeList(AsyncSnapshot<List<TaleModel>> snapshot) {
  //   return ListView.separated(
  //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //     scrollDirection: Axis.horizontal,
  //     itemCount: snapshot.data!.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       var character = snapshot.data![index];
  //       return CharacterWidget(

  //       );
  //     },
  //     separatorBuilder: (BuildContext context, int index) => const SizedBox(
  //       width: 40,
  //     ),
  //   );
  // }
}
