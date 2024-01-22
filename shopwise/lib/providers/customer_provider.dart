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
}

final customerNotifierProvider =
    StateNotifierProvider<CustomerNotifier, Customer>(
        (ref) => CustomerNotifier());
