import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopwise/widgets/fetch_data.dart';

class AllProducts extends StatefulWidget {
  static const routeName = '/all_products';
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
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
