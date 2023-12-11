import 'package:flutter/material.dart';
import 'package:shopwise/widgets/customButton.dart';
import 'package:shopwise/utils/colors.dart';
import 'package:shopwise/widgets/custom_text_form_feild.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            const SizedBox(height: 30),
            CustomButton(
              textColor: Colors.black,
              buttonColor: AppColors.secondaryColor,
              text: "Sign Up",
              onPressed: () {},
            ),
            const SizedBox(height: 30),
            Text("OR"),
            const SizedBox(height: 30),
            CustomButton(
              textColor: Colors.black,
              buttonColor: AppColors.secondaryColor,
              icon: Icons.g_mobiledata,
              text: "Sign Up with Google",
              onPressed: () {},
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {},
                  child: const Text("Sign In"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
