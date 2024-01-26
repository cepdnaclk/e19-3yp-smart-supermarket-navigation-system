import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/login/login.dart';
import 'package:shopwise_web/side_navbar.dart';
import 'package:shopwise_web/widgets/custom_button.dart';

class ConfirmEmail extends StatefulWidget {
  final String email;
  const ConfirmEmail({super.key, required this.email});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmationCodeController = TextEditingController();

  void showTemporaryAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  bool areFieldsFilled() {
    return confirmationCodeController.text.isNotEmpty &&
        usernameController.text.isNotEmpty;
  }

@override
  void initState() {
    super.initState();
    usernameController.text = widget.email;
  }
  
  @override
  void dispose() {
    confirmationCodeController.dispose();
    super.dispose();
  }

  //----------------------------------------
  /// Signs a user up with a username, password, and email. The required
  /// attributes may be different depending on your app's configuration.
  Future<void> confirmUser({
  required String username,
  required String confirmationCode,
}) async {
  try {
    final result = await Amplify.Auth.confirmSignUp(
      username: username,
      confirmationCode: confirmationCode,
    );
    // Check if further confirmations are needed or if
    // the sign up is complete.
    await _handleSignUpResult(result);
  } on AuthException catch (e) {
    showTemporaryAlert(e.message);
    safePrint('Error confirming user: ${e.message}');
  }
}
  
  Future<void> _handleSignUpResult(SignUpResult result) async {
  switch (result.nextStep.signUpStep) {
    case AuthSignUpStep.confirmSignUp:
      final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
      _handleCodeDelivery(codeDeliveryDetails);
      break;
    case AuthSignUpStep.done:
      showTemporaryAlert('Completed Signup.');
      safePrint('Sign up is complete');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: ((context) => const SideNavBar())),
          (route) => false,
        );
      break;
  }
}

  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    showTemporaryAlert("Please check your email for the verification code.");
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
  }


//-----------------------------------------
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
                          height: 460,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white10),
                                child: TextField(
                                  controller:
                                      confirmationCodeController, // Add this line
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Code",
                                    hintStyle: TextStyle(color: Colors.white60),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                radius: 20,
                                textColor: Colors.black,
                                buttonColor: Colors.white70,
                                buttonHeight: 60,
                                buttonWidth: 380,
                                text: "Confirm",
                                onPressed: () {
                                  if (areFieldsFilled()) {
                                    confirmUser(
                                      confirmationCode: confirmationCodeController.text,
                                      username:usernameController.text,
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
                                text: "Sign Up with Google",
                                onPressed: () {},
                              ),
                              //const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account?",
                                      style: TextStyle(color: Colors.white)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                      );
                                    },
                                    child: Text("Sign In",
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
                  height: 650,
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
                            height: 457,
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
                                        confirmationCodeController, // Add this line
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Code",
                                      hintStyle:
                                          TextStyle(color: Colors.white60),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                CustomButton(
                                  radius: 20,
                                  textColor: Colors.black,
                                  buttonColor: Colors.white70,
                                  buttonHeight: 60,
                                  buttonWidth: 380,
                                  text: "Confirm",
                                  onPressed: () {
                                    if (areFieldsFilled()) {
                                      // Perform authentication or any other necessary action
                                      confirmUser(
                                        username: usernameController.text,
                                        confirmationCode: confirmationCodeController.text,
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
                                  text: "Sign Up with Google",
                                  onPressed: () {},
                                ),
                                //const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Already have an account?",
                                        style: TextStyle(color: Colors.white)),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      },
                                      child: Text("Sign In",
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
