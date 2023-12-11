import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  IconData? prefixIcon;
  final bool obscureText;
  //final TextEditingController controller;

  CustomTextFormField({
    Key? key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    //required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextFormField(
        //controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

        ),
      ),
    );
  }
}