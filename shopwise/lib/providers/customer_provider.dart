import 'package:cloud_firestore/cloud_firestore.dart';
import "package:riverpod/riverpod.dart";
import 'package:shopwise/models/customer.dart';

class CustomerNotifier extends StateNotifier<Customer> {
  CustomerNotifier()
      : super(Customer(
            order_id: '',
            sub_uuid: '',
            hashcode: '',
            shopping_date: DateTime.now()));

  void updateCustomer(Customer customer) {
    state = customer;

  }
  String getSubUuid() {
    return state.sub_uuid;
  }

  // Create seperate methods to update each field
  void updateSubUuid(String sub_uuid) {
    state = state.copyWith(sub_uuid: sub_uuid);
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

    // Call the method to save the customer
    customerCollection.add({
      'sub_uuid': state.sub_uuid,
      'hashcode': state.hashcode,
      'order_id': state.order_id,
      'shopping_date': state.shopping_date,
    });
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
