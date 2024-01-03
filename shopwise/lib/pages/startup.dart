import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shopwise/pages/login_screen.dart';

class StartupPage extends StatefulWidget {
  //const StartupPage({super.key});
  static const String routeName = '/startup';

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds and navigate to the login page
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/shopwise_logo.png"),
              width: 350,
              height: 350,
            ),
            Text(
              "Let us make your day!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    ));
  }
}
