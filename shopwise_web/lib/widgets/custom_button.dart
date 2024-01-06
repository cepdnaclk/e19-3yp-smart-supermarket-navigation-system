import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  CustomButton({
    Key? key,
    required this.textColor,
    required this.buttonColor,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconImage,
    this.iconImageSize = 20,
  }):super(key: key);

  final Color textColor;
  final Color buttonColor;
  final String text;
  final VoidCallback onPressed;
  IconData? icon;
  Image? iconImage;
  double buttonWidth = 200;
  double buttonHeight = 40;
  double iconImageSize;

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
        child: icon != null || iconImage!=null ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ? Icon(icon,color: textColor,) : SizedBox(
                      width: iconImageSize,
                      height: iconImageSize,
                      child: iconImage,
                    ),
            const SizedBox(width: 10),
            Text(text,style: TextStyle(fontSize: 16,color: textColor,fontWeight:FontWeight.bold),),
          ],
        ): 
        Text(text,style: TextStyle(fontSize: 16,color: textColor,fontWeight:FontWeight.bold),),
      )
      
    );
  }
}
