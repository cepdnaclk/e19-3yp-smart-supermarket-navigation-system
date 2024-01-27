import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopwise/pages/login_screen.dart';

import 'package:flutter_animated_button/flutter_animated_button.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}):super(key: key);

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    navigateToLogin(); // Call the function to navigate to the login screen after a delay
  }

  // Function to navigate to the login screen
  void navigateToLogin() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/images/shopwise_logo.png"),
        ),
      ),
    );
  }
}

