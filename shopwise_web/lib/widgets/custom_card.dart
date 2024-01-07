import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? cardColor;
  final double? width;
  final double? height;

  const CustomCard({super.key, 
    this.title,
    this.subtitle,
    this.icon,
    this.cardColor,
    this.width,
    this.height,
  });
  

  @override
  Widget build(BuildContext context) {
  return SizedBox(
    width: width, // Set the desired width value
    height: height, // Set the desired height value
    child: Card(
      elevation: 0,
      color: cardColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon!),
        title: Text(title!),
        subtitle: Text(subtitle!),
        
      ),
    ),
  );
}
}