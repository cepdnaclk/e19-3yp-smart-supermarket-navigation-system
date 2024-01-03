import 'package:flutter/material.dart';
import 'package:shopwise/pages/products_list_page.dart';
import 'package:shopwise/pages/register.dart';
import 'package:shopwise/widgets/customButton.dart';
import 'package:shopwise/utils/colors.dart';
import 'package:shopwise/widgets/custom_text_form_feild.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

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
                text: "Sign In",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductsListPage()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 15),
              const Text("OR"),
              const SizedBox(height: 15),
              CustomButton(
                textColor: Colors.black,
                buttonColor: AppColors.secondaryColor,
                iconImage: Image.asset('assets/images/google_logo.png'),
                text: "Sign In with Google",
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text("Register"),
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
