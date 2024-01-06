import 'package:flutter/material.dart';
import 'package:shopwise_web/side_navbar.dart';
import 'package:shopwise_web/widgets/custom_button.dart';

class Placement extends StatefulWidget {
  const Placement({super.key});

  @override
  State<Placement> createState() => _PlacementState();
}

class _PlacementState extends State<Placement> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              const Row(
                children: [
                  Text("Product Placement",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                ],
              ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Container(
                width: screenWidth > 1000 ? 400 : screenWidth * 0.8,
                color: Colors.black12,
              ),
              const SizedBox(width: 20),
              Container(
                width: screenWidth > 1000 ? 400 : screenWidth * 0.8,
                color: Colors.black12,
              ),
            ]
          ),
          ]
        ),
      ),
    );
  }
}