import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.textColor,
    required this.buttonColor,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconImage,
    this.iconImageSize = 20,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.all(10),
    this.buttonHeight = 40,
    this.buttonWidth=200,
    this.radius=20,

  });

  final Color textColor;
  final Color buttonColor;
  final String text;
  final VoidCallback onPressed;
  IconData? icon;
  Image? iconImage;
  double buttonWidth;
  double buttonHeight;
  double iconImageSize;
  EdgeInsets padding;
  EdgeInsets margin;
  double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: buttonWidth,
      height: buttonHeight,
      child: TextButton(
        onPressed: onPressed, // Pass the onPressed callback to the TextButton
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: icon != null || iconImage != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon != null
                      ? Icon(icon, color: textColor)
                      : SizedBox(
                          width: iconImageSize,
                          height: iconImageSize,
                          child: iconImage,
                        ),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}