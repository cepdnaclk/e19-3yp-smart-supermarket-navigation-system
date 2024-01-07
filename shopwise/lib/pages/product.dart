import 'package:flutter/material.dart';

class MyProduct extends StatelessWidget {
  final color;
  final child;

  MyProduct({this.color, this.child});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Popup'),
            content: TextField(
              decoration: InputDecoration(hintText: "Enter something"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        color: color,
        child: Center(child: child),
      ),
    );
  }
}
