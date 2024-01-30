import 'package:cloud_firestore/cloud_firestore.dart';
import "package:riverpod/riverpod.dart";
import 'package:shopwise/models/product.dart';
import 'package:shopwise/providers/customer_provider.dart';

class ShoppingListNotifier extends StateNotifier<List<Product>> {
  ShoppingListNotifier() : super([]);

  // void updateShoppingList(ShoppingList shoppingList) {
  //   state = shoppingList;
  // }

  List<Product> getShoppingProducts(email) {
    final ordersCollection = FirebaseFirestore.instance.collection('orders');
     ordersCollection.get().then((value) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> curentOrder = value.docs
        .where((element) => element.data()['email'] == email)
        .toList();

        
     });
    print("state: ${state}");
    return state;
  }

  void addItem(Product product) {
    state = [...state, product];
  }

  List<int> getShoppingIDsFromDB(String email){
    final ordersCollection = FirebaseFirestore.instance.collection('orders');
    List<int> ids = [];
    ordersCollection.get().then((value) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> curentOrder = value.docs
          .where((element) => element.data()['email'] == email)
          .toList();
      if(curentOrder.isNotEmpty){
        ids = (curentOrder[0].data()['products'] as List)
            .map((e) => int.parse(e.toString()))
            .toList();
      }
    });
    return ids;
  }

  List<int> getShoppingListIDS() {
    print("state: ${state}");
    return state.map((e) => int.parse(e.id)).toList();
  }

  void removeItem(Product product, String email) {
    final ordersCollection = FirebaseFirestore.instance.collection('orders');

    state = state.where((element) => element.id != product.id).toList();
    ordersCollection.get().then((value) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> curentOrder = value.docs
          .where((element) => element.data()['email'] == email)
          .toList();
      //   List<String> existingProducts =
      //     (curentOrder[0].data()['products'] as List)
      //         .map((e) => e.toString())
      //         .toList();
      // existingProducts.addAll(state.map((e) => e.id).toList());
      // print("if case");
      curentOrder[0].reference.update({
        'products': state.map((e) => e.id.toString()).toList(),
      });
    });
  }

  void clearList() {
    state = [];
  }

  void updateList(List<Product> products) {
    state = products;
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

        List<QueryDocumentSnapshot<Map<String, dynamic>>> curentOrder = value
            .docs
            .where((element) => element.data()['email'] == email)
            .toList();
        // Update the entry
        if (curentOrder.isNotEmpty) {
          List<String> existingProducts =
              (curentOrder[0].data()['products'] as List)
                  .map((e) => e.toString())
                  .toList();
          List<String> newProducts = (state.map((e) => e.id).toList())
              .where((element) => existingProducts.contains(element) == false)
              .toList();
          existingProducts.addAll(newProducts);
          print("if case");
          curentOrder[0].reference.update({
            'id': sub_UUID,
            'products': existingProducts,
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
