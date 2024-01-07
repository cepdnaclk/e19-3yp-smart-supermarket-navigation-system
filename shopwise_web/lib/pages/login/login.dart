import 'package:flutter/material.dart';
import 'package:shopwise_web/side_navbar.dart';
import 'package:shopwise_web/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool areFieldsFilled() {
    return usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                offset: const Offset(0, 3), // Set the offset of the shadow
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white10),
                        child: TextField(
                          controller: usernameController, // Add this line
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
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
                        child: TextField(
                          controller: passwordController, // Add this line
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white60)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        textColor: Colors.black,
                        buttonColor: Colors.white70,
                        buttonHeight: 60,
                        text: "Log In",
                        onPressed: () {
                          if (areFieldsFilled()) {
                            // Perform authentication or any other necessary action

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: ((context) => const SideNavBar())),
                              (route) => false,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color.fromARGB(255, 207, 237, 212),
                                  title:const Center(child:  Text('Error',
                                      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),),
                                  content:const Text(
                                      'Please fill in all the fields.',style:TextStyle(fontWeight: FontWeight.bold)),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK',style: TextStyle(color: Colors.black),),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
