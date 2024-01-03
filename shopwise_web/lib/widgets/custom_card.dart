import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const CustomCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}