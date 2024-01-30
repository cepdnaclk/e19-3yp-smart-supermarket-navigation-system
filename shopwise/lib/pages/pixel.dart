import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  final color;
  final child;

  MyPixel({this.color, this.child});

  @override
  Widget build(BuildContext context) {
    debugPrint("MyPixel urlLink......: $child");
    return Container(
      color: color,
      child: child,
    );
  }
}
