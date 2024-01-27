import 'package:flutter/material.dart';

class TheBill extends StatelessWidget {
  static const routeName = '/the_bill';
  const TheBill({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("The Bill"),
        ),
        body: Center(
          child: Text("The bill"),
        ));
  }
}
