import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class LoadingWidget extends StatelessWidget {
  final String text;
  const LoadingWidget({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    developer.log("Build Loading Dialog", name: "LoadingWidget");
    return Dialog(
      // The background color
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The loading indicator
            const CircularProgressIndicator(),
            const SizedBox(
              height: 15,
            ),
            // Some text
            Text(text)
          ],
        ),
      ),
    );
  }
}
