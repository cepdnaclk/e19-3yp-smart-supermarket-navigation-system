import 'package:flutter/material.dart';

class ProductPixel extends StatelessWidget {
  final color;
  final child;

  ProductPixel({this.color, this.child});

  @override
  Widget build(BuildContext context) {
    debugPrint("My Product....... Pixel urlLink......: $child");
    return Container(
      color: color,
      child: child,
    );
  }
}
