import 'package:flutter/material.dart';

class ShowProduct extends StatelessWidget {
  final color;
  final child;
  // final imageUrl;
  const ShowProduct({super.key, required this.color, required this.child});

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