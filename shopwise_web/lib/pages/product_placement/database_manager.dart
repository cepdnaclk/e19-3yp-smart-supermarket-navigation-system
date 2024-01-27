import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  List productLists = [];
  List orderLists = []; // new list for orders
  List customers = []; // new list for customers

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('products');

  final CollectionReference orderCollectionRef = FirebaseFirestore.instance
      .collection('orders'); // new reference for orders

  final CollectionReference customerCollectionRef = FirebaseFirestore.instance
      .collection('customers'); // new reference for orders

  Future<List> getData() async {
    try {
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          productLists.add(result.data());
        }
      });

      debugPrint(productLists.toString());

      return productLists;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<List> getOrderData() async {
    // new method for orders
    try {
      await orderCollectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          orderLists.add(result.data());
        }
      });

      debugPrint(orderLists.toString());

      return orderLists;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<List> getCustomerData() async {
    // new method for orders
    try {
      await customerCollectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          customers.add(result.data());
        }
      });

      debugPrint(customers.toString());

      return customers;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }
}
