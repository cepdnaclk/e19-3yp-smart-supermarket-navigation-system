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

  void saveShoppingList(String sub_UUID, String email) {
    // Get a reference to the database collection 'customers'
    final ordersCollection = FirebaseFirestore.instance.collection('orders');

    // Fetch data from orders collection and check whether there is an entry with the current sub_UUID
    // If there is an entry, update the entry with the current shopping list
    // If there is no entry, create a new entry with the current shopping list
    // final query = ordersCollection.where('id', isEqualTo: sub_UUID);
    // print("query: ${query}");

    ordersCollection.get().then((value) {
      if (value.docs.length == 0) {
        print("creating");
        // Create a new entry
        ordersCollection.add({
          'id': sub_UUID,
          'email': email,
          'products': state.map((e) => e.id).toList(),
        });
      } else {
        print("updating");

        List<QueryDocumentSnapshot<Map<String, dynamic>>> curentOrder =
            value.docs.where((element) => element.data()['email'] == email).toList();
        // Update the entry
        if (curentOrder.isNotEmpty) {
          print("if case");
          curentOrder[0].reference.update({
            'id': sub_UUID,
            'products': state.map((e) => e.id).toList(),
          });
        } else {
          print("else case");
          ordersCollection.add({
            'id': sub_UUID,
            'email': email,
            'products': state.map((e) => e.id).toList(),
          });
        }
      }
    });

    // Call the method to save the customer
    // ordersCollection.add({
    //   'id': sub_UUID,
    //   'products': state.map((e) => e.id).toList(),
    // });

    print("saved!");
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<Product>>(
        (ref) => ShoppingListNotifier());
