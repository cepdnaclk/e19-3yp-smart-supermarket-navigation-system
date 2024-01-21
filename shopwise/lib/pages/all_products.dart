import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopwise/widgets/fetch_data.dart';

class MyWidget extends StatefulWidget {
  static const routeName = '/all_products';
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Products"),
        ),
        body: Column(children: [
          Expanded(child: fetchData("Products", productsCollection))
        ]));
  }
}
