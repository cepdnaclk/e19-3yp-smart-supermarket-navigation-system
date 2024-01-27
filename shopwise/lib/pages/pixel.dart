import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  final color;
  final child;

  MyPixel({this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        color: color,
        child: Center(child: child),
      ),
    );
  }
}
