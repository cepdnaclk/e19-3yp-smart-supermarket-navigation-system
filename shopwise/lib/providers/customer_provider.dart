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
    saveCustomer(state);
  }
}

// Method to save the state in firebase database, 'customers' collection
void saveCustomer(Customer customer) {
  // Get a reference to the database collection 'customers'
  final customerCollection = FirebaseFirestore.instance.collection('customers');

  // Call the method to save the customer
  customerCollection.add({
    'sub_uuid': customer.sub_uuid,
    'hashcode': customer.hashcode,
    'order_id': customer.order_id,
    'shopping_date': customer.shopping_date,
  });
}

final customerNotifierProvider =
    StateNotifierProvider<CustomerNotifier, Customer>(
        (ref) => CustomerNotifier());
