import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ResizableImage extends StatefulWidget {
  final File image;
  final Function(int, int) onUpdate;
  const ResizableImage(
      {super.key, required this.image, required this.onUpdate});

  @override
  _ResizableImageState createState() => _ResizableImageState();
}

class _ResizableImageState extends State<ResizableImage> {
  final double _scale = 1.0;
  double width = 100.0;
  double height = 100.0;
  double x = 300.0;
  double y = 150.0;
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
            width += 100;
            height += 100;
          });
        },
        onLongPressMoveUpdate: (details) {
          RenderBox? stackRenderBox = context.findRenderObject() as RenderBox?;
          if (stackRenderBox != null) {
            Offset localOffset =
                stackRenderBox.globalToLocal(details.globalPosition);
            setState(() {
              x = localOffset.dx;
              y = localOffset.dy;
              developer.log(x.toString(), name: "x");
              developer.log(y.toString(), name: "y");
              widget.onUpdate(x.ceil(), y.ceil());
            });
          }
        },
        child: Image.file(
          widget.image,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
