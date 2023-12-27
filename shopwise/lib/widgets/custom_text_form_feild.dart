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
      height: 55,
      child: prefixIcon != null? TextFormField(
        //controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black),
          ),
    
        ),
      )
      :TextFormField(
        //controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black)),
    
        ),
      )
    );
  }
}