import 'package:flutter/material.dart';
import 'package:shopwise_web/side_navbar.dart';
import 'package:shopwise_web/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 199, 230, 203),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 134, 153, 136)
                    .withOpacity(0.5), // Set the shadow color
                spreadRadius: 5, // Set the spread radius of the shadow
                blurRadius: 3, // Set the blur radius of the shadow
                offset:const Offset(0, 3), // Set the offset of the shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          height: 500,
          width: screenWidth > 50 ? 400 : screenWidth * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/shopwise_logo.png", width: 150),
                const SizedBox(height: 20),
                Container(
                    //height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 51, 120, 64),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white10),
                        child: const TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Username",
                            hintStyle: TextStyle(color: Colors.white60),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white10),
                        child: const TextField(
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white60))),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        textColor: Colors.black,
                        buttonColor: Colors.white70,
                        text: "Log In",
                        onPressed: () {
                          //authentication part
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                              builder: ((context) => const SideNavBar())), (route) => false);
                        },
                      )
                    ]),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
