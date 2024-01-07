import 'package:flutter/material.dart';

class TheBill extends StatelessWidget {
  static const routeName = '/the-bill';
  const TheBill({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Bill"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [
          Expanded(
            child: ListView(
              children: [Image.asset('assets/images/bill.jpg')],
            ),
          )
        ],
      ),
    );
  }
}
