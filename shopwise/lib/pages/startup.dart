import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shopwise/pages/chooseview.dart';
import 'package:shopwise/pages/login_screen.dart';

import 'package:flutter_animated_button/flutter_animated_button.dart';

class StartupPage extends StatefulWidget {
  //const StartupPage({super.key});
  static const String routeName = '/';

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("assets/images/shopwise_logo.png"),
            width: 350,
            height: 350,
          ),
          const Text(
            "Let us make your day!",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(
            height: 50,
          ),
          AnimatedButton(
            onPress: () {
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.pushReplacementNamed(context, Choose.routeName);
              });

              // Navigator.pushReplacementNamed(context, Choose.routeName);
            },
            height: 50,
            width: 160,
            text: "Get Started Now!",
            textStyle: TextStyle(color: Colors.black, fontSize: 20),
            isReverse: true,
            selectedTextColor: Colors.black,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            // textStyle: submitTextStyle,
            backgroundColor: Colors.green,
            borderColor: Colors.white,
            borderRadius: 10,
            borderWidth: 2,
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     onPrimary: Colors.white,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          //   ),
          //   onPressed: () {
          //     Navigator.pushReplacementNamed(context, Choose.routeName);
          //   },
          //   child: const Text("Get Started"),
          // ),
        ],
      ),
    ));
  }
}
