import 'package:flutter/material.dart';
import 'package:igrim/screens/home_screen.dart';
import 'package:igrim/screens/login_screen.dart';
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
      theme: ThemeData(
        fontFamily: 'Cafe24Ssurround',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
