import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.textColor,
    required this.buttonColor,
    required this.text,
    required this.onPressed,
    this.icon,
  }):super(key: key);

  final Color textColor;
  final Color buttonColor;
  final String text;
  final VoidCallback onPressed;
  IconData? icon;
  double buttonWidth = 300;
  double buttonHeight = 50;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: icon != null ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 10,),
            Text(text,style: TextStyle(fontSize: 20,color: textColor,fontWeight:FontWeight.bold),),
          ],
        ): 
        Text(text,style: TextStyle(fontSize: 20,color: textColor,fontWeight:FontWeight.bold),),
      )
      
    );
  }
}
