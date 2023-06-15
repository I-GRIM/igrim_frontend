import 'package:flutter/material.dart';

class NotifyWidget extends StatelessWidget {
  List<String> right;
  List<String> wrong;
  NotifyWidget({super.key, required this.right, required this.wrong});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // The background color
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < right.length; i++)
                Text(
                  "${wrong[i]}(를)을 ${right[i]}(으)로 바꿔주세요",
                  style: const TextStyle(fontSize: 16),
                )
            ],
          ),
        ),
      ),
    );
  }
}
