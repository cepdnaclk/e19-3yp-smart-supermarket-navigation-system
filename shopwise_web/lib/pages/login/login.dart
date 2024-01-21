// import 'package:flutter/material.dart';
// import 'package:shopwise_web/side_navbar.dart';
// import 'package:shopwise_web/widgets/custom_button.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   bool areFieldsFilled() {
//     return usernameController.text.isNotEmpty &&
//         passwordController.text.isNotEmpty;
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Center(
//         child: Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: const Color.fromARGB(255, 199, 230, 203),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color.fromARGB(255, 134, 153, 136)
//                     .withOpacity(0.5), // Set the shadow color
//                 spreadRadius: 5, // Set the spread radius of the shadow
//                 blurRadius: 3, // Set the blur radius of the shadow
//                 offset: const Offset(0, 3), // Set the offset of the shadow
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(20),
//           height: 500,
//           width: screenWidth > 50 ? 400 : screenWidth * 0.8,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Image.asset("assets/images/shopwise_logo.png", width: 150),
//                 const SizedBox(height: 20),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: const Color.fromARGB(255, 51, 120, 64),
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.white10),
//                         child: TextField(
//                           controller: usernameController, // Add this line
//                           style: const TextStyle(color: Colors.white),
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "Username",
//                             hintStyle: TextStyle(color: Colors.white60),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.white10),
//                         child: TextField(
//                           controller: passwordController, // Add this line
//                           style: const TextStyle(color: Colors.white),
//                           obscureText: true,
//                           decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               hintText: "Password",
//                               hintStyle: TextStyle(color: Colors.white60)),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       CustomButton(
//                         textColor: Colors.black,
//                         buttonColor: Colors.white70,
//                         buttonHeight: 60,
//                         text: "Log In",
//                         onPressed: () {
//                           if (areFieldsFilled()) {
//                             // Perform authentication or any other necessary action

//                             Navigator.of(context).pushAndRemoveUntil(
//                               MaterialPageRoute(
//                                   builder: ((context) => const SideNavBar())),
//                               (route) => false,
//                             );
//                           } else {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 207, 237, 212),
//                                   title: const Center(
//                                     child: Text('Error',
//                                         style: TextStyle(
//                                             color: Colors.red,
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold)),
//                                   ),
//                                   content: const Text(
//                                       'Please fill in all the fields.',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                   actions: [
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text(
//                                         'OK',
//                                         style: TextStyle(color: Colors.black),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           }
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/login/register.dart';
import 'package:shopwise_web/side_navbar.dart';
import 'package:shopwise_web/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Expanded(
        child: width > 900
            ? Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: Image(
                            image:
                                AssetImage('assets/images/shopwise_logo.png'),
                            width: 270,
                            height: 270,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      color: Color.fromARGB(255, 58, 142, 61),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          height: 400,
                          width: 380,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white10),
                                child: TextField(
                                  controller:
                                      usernameController, // Add this line
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white10),
                                child: TextField(
                                  controller:
                                      passwordController, // Add this line
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.white60)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                radius: 20,
                                textColor: Colors.black,
                                buttonColor: Colors.white70,
                                buttonHeight: 60,
                                buttonWidth: 380,
                                text: "Sign In",
                                onPressed: () {
                                  if (areFieldsFilled()) {
                                    // Perform authentication or any other necessary action

                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const SideNavBar())),
                                      (route) => false,
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: const Color.fromARGB(
                                              255, 207, 237, 212),
                                          title: const Center(
                                            child: Text('Error',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          content: const Text(
                                              'Please fill in all the fields.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                              const Text("OR",
                                  style: TextStyle(color: Colors.white)),
                              //const SizedBox(height: 0),
                              CustomButton(
                                textColor: Colors.black,
                                buttonColor: Colors.white70,
                                buttonHeight: 60,
                                buttonWidth: 380,
                                iconImage: Image.asset(
                                    'assets/images/google_logo.png'),
                                text: "Sign In with Google",
                                onPressed: () {},
                              ),
                              //const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?",
                                      style: TextStyle(color: Colors.white)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage()),
                                        (route) => false,
                                      );
                                    },
                                    child: Text("Register Now",
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7))),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Container(
                  height: 600,
                  width: 430,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 195, 241, 196),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 134, 153, 136)
                            .withOpacity(0.5), // Set the shadow color
                        spreadRadius: 3, // Set the spread radius of the shadow
                        blurRadius: 20, // Set the blur radius of the shadow
                        //offset: const Offset(0, 3), // Set the offset of the shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Center(
                            child: Image(
                              image:
                                  AssetImage('assets/images/shopwise_logo.png'),
                              width: 150,
                              height: 150,
                            ),
                          ),
                          Container(
                            height: 400,
                            width: 380,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 68, 155, 70),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 30),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white10),
                                  child: TextField(
                                    controller:
                                        usernameController, // Add this line
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle:
                                          TextStyle(color: Colors.white60),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white10),
                                  child: TextField(
                                    controller:
                                        passwordController, // Add this line
                                    style: const TextStyle(color: Colors.white),
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.white60)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  radius: 20,
                                  textColor: Colors.black,
                                  buttonColor: Colors.white70,
                                  buttonHeight: 60,
                                  buttonWidth: 380,
                                  text: "Sign In",
                                  onPressed: () {
                                    if (areFieldsFilled()) {
                                      // Perform authentication or any other necessary action

                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const SideNavBar())),
                                        (route) => false,
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 207, 237, 212),
                                            title: const Center(
                                              child: Text('Error',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            content: const Text(
                                                'Please fill in all the fields.',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                                const Text("OR",
                                    style: TextStyle(color: Colors.white)),
                                //const SizedBox(height: 0),
                                CustomButton(
                                  textColor: Colors.black,
                                  buttonColor: Colors.white70,
                                  buttonHeight: 60,
                                  buttonWidth: 380,
                                  iconImage: Image.asset(
                                      'assets/images/google_logo.png'),
                                  text: "Sign In with Google",
                                  onPressed: () {},
                                ),
                                //const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account?",
                                        style: TextStyle(color: Colors.white)),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterPage()),
                                          (route) => false,
                                        );
                                      },
                                      child: Text("Register Now",
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.7))),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
