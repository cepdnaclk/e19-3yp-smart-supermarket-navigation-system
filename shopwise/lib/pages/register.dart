import 'package:flutter/material.dart';
import 'package:shopwise/pages/login_screen.dart';
import 'package:shopwise/widgets/customButton.dart';
import 'package:shopwise/utils/colors.dart';
import 'package:shopwise/widgets/custom_text_form_feild.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/images/secondary.png"),
              ),
              const SizedBox(height: 60),
              CustomTextFormField(
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 50),
              CustomButton(
                textColor: Colors.black,
                buttonColor: AppColors.secondaryColor,
                text: "Sign Up",
                onPressed: () {},
              ),
              const SizedBox(height: 15),
              const Text("OR"),
              const SizedBox(height: 15),
              CustomButton(
                textColor: Colors.black,
                buttonColor: AppColors.secondaryColor,
                iconImage: Image.asset('assets/images/google_logo.png'),
                text: "Sign Up with Google",
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text("Sign In"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
