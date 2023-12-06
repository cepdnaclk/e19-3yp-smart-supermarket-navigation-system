import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ShopWise",
        ),
      ),
      body: const Center(
        child: Image(
          image: AssetImage("assets/images/secondary.png"),
        ),
      ),
    );
  }
}
