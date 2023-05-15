import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ResizableImage extends StatefulWidget {
  final String image;
  const ResizableImage({
    super.key,
    required this.image,
  });

  @override
  _ResizableImageState createState() => _ResizableImageState();
}

class _ResizableImageState extends State<ResizableImage> {
  final double _scale = 1.0;
  double width = 100.0;
  double height = 100.0;
  double x = 10.0;
  double y = 10.0;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            developer.log(_scale.toString(), name: "scale");
            double hs = details.horizontalScale.clamp(0.3, 3);
            double vs = details.verticalScale.clamp(0.3, 3);
            width = (width * hs).clamp(50, 400);
            height = (height * vs).clamp(50, 400);
          });
        },
        onDoubleTap: () {
          setState(() {
            width = 100;
            height = 100;
          });
        },
        onLongPressMoveUpdate: (details) {
          setState(() {
            x = details.localPosition.dx;
            y = details.localPosition.dy;
            developer.log(x.toString(), name: "x : ");
            developer.log(y.toString(), name: "y : ");
          });
        },
        child: Image.network(
          widget.image,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
