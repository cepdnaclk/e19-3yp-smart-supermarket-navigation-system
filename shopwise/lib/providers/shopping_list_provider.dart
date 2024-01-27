import 'package:cloud_firestore/cloud_firestore.dart';
import "package:riverpod/riverpod.dart";
import 'package:shopwise/models/product.dart';
import 'package:shopwise/providers/customer_provider.dart';

class ShoppingListNotifier extends StateNotifier<List<Product>> {
  ShoppingListNotifier() : super([]);

  // void updateShoppingList(ShoppingList shoppingList) {
  //   state = shoppingList;
  // }

  void addItem(Product product) {
    state = [...state, product];
  }

  void removeItem(Product product) {
    state = state.where((element) => element.id != product.id).toList();
  }

  void clearList() {
    state = [];
  }

  void saveShoppingList(String sub_UUID) {
    // Get a reference to the database collection 'customers'
    final ordersCollection = FirebaseFirestore.instance.collection('orders');

 

    // Call the method to save the customer
    ordersCollection.add({
      'id': sub_UUID,
      'products': state.map((e) => e.id).toList(),
    });

    print("saved!");
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<Product>>(
        (ref) => ShoppingListNotifier());
