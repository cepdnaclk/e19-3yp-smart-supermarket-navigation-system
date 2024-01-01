import 'package:flutter/material.dart';
import 'package:shopwise/pages/login_screen.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => LoginScreen())));
            },
            child: Text("Get Started"),
          ),
        ],
      ),
    ));
  }
}
