import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:riverpod/riverpod.dart";
import 'package:shopwise/models/customer.dart';

class CustomerNotifier extends StateNotifier<Customer> {
  CustomerNotifier()
      : super(Customer(
            order_id: '',
            email: '',
            sub_uuid: '',
            hashcode: '',
            shopping_date: DateTime.now()));

  void updateCustomer(Customer customer) {
    state = customer;
  }

  String getSubUuid() {
    return state.sub_uuid;
  }

  String getEmail() {
    return state.email;
  }

  // Create seperate methods to update each field
  void updateSubUuid(String sub_uuid) {
    state = state.copyWith(sub_uuid: sub_uuid);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateHashcode(String hashcode) {
    state = state.copyWith(hashcode: hashcode);
  }

  void updateOrderId(String order_id) {
    state = state.copyWith(order_id: order_id);
  }

  void updateShoppingDate(DateTime shopping_date) {
    state = state.copyWith(shopping_date: shopping_date);
  }

  // Method to save the state in firebase database, 'customers' collection
  void saveCustomer() {
    // Get a reference to the database collection 'customers'
    final customerCollection =
        FirebaseFirestore.instance.collection('customers');

    // Fetch data from customers collection and check whether there is an entry with the current email
    // If there is an entry, update the entry with the sub_uuid, hashcode, order_id and shopping_date
    // If there is no entry, create a new entry with the sub_uuid, hashcode, order_id and shopping_date, email
    customerCollection.get().then((value) => {
          print("value.docs.length..............: ${value.docs.length}"),
          print(value.docs
              .where((element) => element.data()['email'] == state.email)
              .toList()),
          if (value.docs.length == 0)
            {
              print("creating............"),
              // Create a new entry
              customerCollection.add({
                'sub_uuid': state.sub_uuid,
                'email': state.email,
                'hashcode': state.hashcode,
                'order_id': state.order_id,
                'shopping_date': state.shopping_date,
              })
            }
          else
            {
              print("updating"),
              if (value.docs
                      .where(
                          (element) => element.data()['email'] == state.email)
                      .toList()
                      .length ==
                  0)
                {
                  customerCollection.add({
                    'sub_uuid': state.sub_uuid,
                    'email': state.email,
                    'hashcode': state.hashcode,
                    'order_id': state.order_id,
                    'shopping_date': state.shopping_date,
                  })
                }
              else
                {
                  value.docs
                      .where(
                          (element) => element.data()['email'] == state.email)
                      .toList()[0]
                      .reference
                      .update({
                    'sub_uuid': state.sub_uuid,
                    'hashcode': state.hashcode,
                    'order_id': state.order_id,
                    'shopping_date': state.shopping_date,
                  })
                }

              // List<QueryDocumentSnapshot<>> currentCustomer = value.docs.where((element) => element.data()['email'] == state.email).toList(),
            }
        });

    // Update the entry

    // Call the method to save the customer
  }
}

// // Method to save the state in firebase database, 'customers' collection
// void saveCustomer(Customer customer) {
//   // Get a reference to the database collection 'customers'
//   final customerCollection = FirebaseFirestore.instance.collection('customers');

//   // Call the method to save the customer
//   customerCollection.add({
//     'sub_uuid': customer.sub_uuid,
//     'hashcode': customer.hashcode,
//     'order_id': customer.order_id,
//     'shopping_date': customer.shopping_date,
//   });
// }

final customerNotifierProvider =
    StateNotifierProvider<CustomerNotifier, Customer>(
        (ref) => CustomerNotifier());
