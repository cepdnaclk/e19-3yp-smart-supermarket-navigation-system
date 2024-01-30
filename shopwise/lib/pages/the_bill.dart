import 'package:flutter/material.dart';

class TheBill extends StatelessWidget {
  static const routeName = '/the_bill';
  const TheBill({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Check Your Total"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Image.asset("assets/images/bill.jpg"),
              ListTile(
                trailing: Text("Rs. 500"),
                title: Text("Vaseline × 1"),
              ),
              ListTile(
                trailing: Text("Rs. 200"),
                title: Text("Tooth Paste × 1"),
              ),
              ListTile(
                trailing: Text("Rs. 120"),
                title: Text("Tooth Brush × 1"),
              ),
              ListTile(
                trailing: Text("Rs. 350"),
                title: Text("Chocolate Biscuit × 1"),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 1,
                color: Colors.green.shade500,
              ),
              ListTile(
                trailing: Text(
                  "Rs. 1170",
                  style: TextStyle(
                      color: Colors.green.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                title: Text(
                  "Total",
                  style: TextStyle(
                      color: Colors.green.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 2,
                color: Colors.green.shade500,
              ),
            ]),
          ),
        ));
  }
}
