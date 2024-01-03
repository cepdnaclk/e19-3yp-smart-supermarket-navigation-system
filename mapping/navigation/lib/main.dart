import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navigation/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  StreamController<String> streamController = StreamController<String>();

  void startSending() {
    List<String> directions = [
      '159',
      '148',
      '147',
      '146',
      '145',
      '134',
      '123',
      '112',
      '113',
      '114',
      '115',
      '116',
      '117',
      '118',
      '129',
      '140',
      '151',
      '150',
      '149',
      '148',
      '159'
    ];
    int index = 0;

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (index < directions.length) {
        streamController.add(directions[index]);
        index++;
      } else {
        t.cancel();
        //streamController.close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startSending();
    return MaterialApp(
      home: HomePage(directionStream: streamController.stream),
    );
  }
}
