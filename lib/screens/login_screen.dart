import 'package:flutter/material.dart';
import 'package:igrim/dtos/login_req_dto.dart';
import 'package:igrim/screens/home_screen.dart';
import 'package:igrim/services/auth_service.dart';
import 'dart:developer' as developer;

import 'package:igrim/services/jwt_service.dart';
import 'package:igrim/widgets/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("로그인"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                        width: 200,
                        height: 150,
                        /*decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50.0)),*/
                        child: Image.asset('assets/imgs/logo.jpg')),
                  ],
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이메일',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호',
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 15, top: 5),
              child: Text(errorMessage,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  )),
            ),
            TextButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: const Text(
                '비밀번호 찾기',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  developer.log(
                      "email : ${emailController.text}, password : ${passwordController.text}",
                      name: "LoginScreen");
                  showDialog(
                      // The user CANNOT close this dialog  by pressing outsite it
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return const LoadingWidget(text: "로그인 중...");
                      });
                  try {
                    await AuthService.userLogin(LoginReqDto(
                      emailController.text,
                      passwordController.text,
                      "kenny",
                    )).then((loginResDto) => {
                          Navigator.of(context).pop(),
                          JwtService.storeJwt(loginResDto).then((value) => {
                                if (value)
                                  {
                                    developer.log("finished"),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen())),
                                  }
                              })
                        });
                  } on Exception catch (e) {
                    Navigator.of(context).pop();
                    developer.log(e.toString(), name: "LoginScreen");
                    setState(() {
                      errorMessage = e.toString();
                    });
                  }
                },
                child: const Text(
                  '로그인',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
            const Text('회원가입')
          ],
        ),
      ),
    );
  }
}
