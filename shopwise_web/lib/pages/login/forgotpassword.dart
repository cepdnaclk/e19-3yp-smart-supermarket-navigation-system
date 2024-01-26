import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/login/login.dart';
import 'package:shopwise_web/widgets/custom_button.dart';

class ForgotPassword extends StatefulWidget {
  final String username;
  const ForgotPassword({super.key, required this.username});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmationCodeController = TextEditingController();

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username;
  }

  void showDialogMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 207, 237, 212),
          title: const Center(
            child: Text(
              'Error',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            msg, // Use the provided message parameter
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void areAllFieldsFilles() {
    if (usernameController.text.isNotEmpty &&
        newpasswordController.text.isNotEmpty &&
        confirmationCodeController.text.isNotEmpty) {
      confirmResetPassword(
          username: usernameController.text,
          newPassword: newpasswordController.text,
          confirmationCode: confirmationCodeController.text);
    } else {
      showDialogMessage('Please fill in all the fields.');
    }
  }

  Future<void> confirmResetPassword({
    required String username,
    required String newPassword,
    required String confirmationCode,
    
  }) async {
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: username,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      safePrint('Password reset complete: ${result.isPasswordReset}');
      showDialogMessage("Password Reset Complete.");
       Future.delayed(const Duration(milliseconds: 100)).then((_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage( username: usernameController.text,),
          ));
       });
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
    }
  }

//fetch user data
  Future<void> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        safePrint('key: ${element.userAttributeKey}; value: ${element.value}');
      }
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
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
                                  color: Colors.white10,
                                ),
                                child: TextField(
                                  controller: newpasswordController,
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "New Password",
                                    hintStyle: TextStyle(color: Colors.white60),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white,
                                      ),
                                    ),
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
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Verification code",
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
                                text: "Reset Password",
                                onPressed: () {
                                  areAllFieldsFilles();
                                },
                              ),
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
                                    color: Colors.white10,
                                  ),
                                  child: TextField(
                                    controller: newpasswordController,
                                    style: const TextStyle(color: Colors.white),
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "New Password",
                                      hintStyle:
                                          TextStyle(color: Colors.white60),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.white,
                                        ),
                                      ),
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
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "confirmation code",
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
                                  text: "Reset Password",
                                  onPressed: () {
                                    areAllFieldsFilles();
                                  },
                                ),
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
